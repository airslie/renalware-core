### UKRDC GPG encryption

UKRDC provide a
[public gpg key](https://github.com/renalreg/ukrr_public_keys/blob/main/UKRDC/UKRDC_Public.asc)
that we use to encrypt data we send to them. The key is included in the code base here.

In order to gpg encrypt files we need to import this public key into a keyring, and then use
the recipient name ('UKRDC') so gpg can choose the correct key. Currently there seems to be no gpg
support for encryping a message just by specifying a public key file, so we create and ship
a specific keyring with just this public key in it.

To re-create the keyring

```
gpg --import --no-default-keyring --keyring ./ukrdc_keyring.gpg  ./ukrdc_public.asc
```

You can list the keys in the keyring to check there is one for the recipient 'UKRDC':

```
gpg --keyring ./ukrdc_keyring.gpg --list-keys
```

The recipient name 'UKRDC' is configurable via an ENV var (see configuration.rb) so if you do end up
recreating the keyring and the gpg recipient changes, you will need to update the env var at all
sites.
