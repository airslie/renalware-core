CREATE OR REPLACE FUNCTION pseudo_encrypt(VALUE int) returns int AS $$
/*
   See  https://wiki.postgresql.org/wiki/Skip32
   Encrypts an integer (4 bytes) with the Skip32 block cipher
   based on Skipjack.
   Arguments:
      - int4 value to encrypt/decrypt
      - bytea encryption key, 10 bytes long
      - direction: true to encrypt, false to decrypt

   Encrypt usage:
     select skip32(1234, bytea '\xC0ffeeFaceC0ffeeFeed', true);
   Decrypt usage:
     select skip32(783287961, bytea '\xC0ffeeFaceC0ffeeFeed', false);

   As each value encrypts into another unique value (given an encryption
   key), this may be used to obfuscate an int4 primary key without loosing
   the unicity property.

   plpgsql implementation by Daniel Vérité.
   Based on C code from:
     SKIP32 -- 32 bit block cipher based on SKIPJACK.
     Written by Greg Rose, QUALCOMM Australia, 1999/04/27.
   See also:
     http://search.cpan.org/~esh/Crypt-Skip32-0.17/
*/
CREATE OR REPLACE FUNCTION skip32(val int4, cr_key bytea, encrypt bool) returns int4
AS $$
DECLARE
  kstep int;
  k int;
  wl int4;
  wr int4;
  g1 int4;
  g2 int4;
  g3 int4;
  g4 int4;
  g5 int4;
  g6 int4;
  ftable bytea:='\xa3d70983f848f6f4b321157899b1aff9e72d4d8ace4cca2e5295d91e4e3844280adf02a017f1606812b77ac3e9fa3d5396846bbaf2639a197caee5f5f7166aa239b67b0fc193811beeb41aead0912fb855b9da853f41bfe05a58805f660bd89035d5c0a733066569450094566d989b7697fcb2c2b0fedb20e1ebd6e4dd474a1d42ed9e6e493ccd4327d207d4dec7671889cb301f8dc68faac874dcc95d5c31a47088612c9f0d2b8750825464267d0340344b1c73d1c4fd3bccfb7fabe63e5ba5ad04239c145122f02979717eff8c0ee20cefbc72756f37a1ecd38e628b8610e8087711be924f24c532369dcff3a6bbac5e6ca9135725b5e3bda83a0105592a46';
BEGIN
  IF (octet_length(cr_key)!=10) THEN
    RAISE EXCEPTION 'The encryption key must be exactly 10 bytes long.';
  END IF;

  IF (encrypt) THEN
    kstep := 1;
    k := 0;
  ELSE
    kstep := -1;
    k := 23;
  END IF;

  wl := (val & -65536) >> 16;
  wr := val & 65535;

  FOR i IN 0..11 LOOP
    g1 := (wl>>8) & 255;
    g2 := wl & 255;
    g3 := get_byte(ftable, g2 # get_byte(cr_key, (4*k)%10)) # g1;
    g4 := get_byte(ftable, g3 # get_byte(cr_key, (4*k+1)%10)) # g2;
    g5 := get_byte(ftable, g4 # get_byte(cr_key, (4*k+2)%10)) # g3;
    g6 := get_byte(ftable, g5 # get_byte(cr_key, (4*k+3)%10)) # g4;
    wr := wr # (((g5<<8) + g6) # k);
    k := k + kstep;

    g1 := (wr>>8) & 255;
    g2 := wr & 255;
    g3 := get_byte(ftable, g2 # get_byte(cr_key, (4*k)%10)) # g1;
    g4 := get_byte(ftable, g3 # get_byte(cr_key, (4*k+1)%10)) # g2;
    g5 := get_byte(ftable, g4 # get_byte(cr_key, (4*k+2)%10)) # g3;
    g6 := get_byte(ftable, g5 # get_byte(cr_key, (4*k+3)%10)) # g4;
    wl := wl # (((g5<<8) + g6) # k);
    k := k + kstep;
  END LOOP;

  RETURN (wr << 16) | (wl & 65535);

END
$$ immutable strict language plpgsql;
