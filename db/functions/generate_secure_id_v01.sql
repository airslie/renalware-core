CREATE OR REPLACE FUNCTION generate_secure_id(length integer default 24)
  /*
  Generates and returns a unique base 58 token of <length> length for use in for example
  the obfuscation of database ids in URLs.
  Note base58 tokens are case sensitive.
  Example usage:
    select generate_secure_id(24) #=> 0KPNXf4X5x1o6O4mXWE5MC9H
  TC 8.6.2017
  */
  RETURNS text AS
  $body$
  SELECT string_agg (substr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                     ceil (random() * 62)::integer,
                     1), '')
  FROM   generate_series(1, length)
  ;
  $body$
  LANGUAGE sql;
