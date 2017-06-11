class CreateFunctionsToGenerateSecurePatientId < ActiveRecord::Migration[5.0]
 def up
    sql = <<-SQL.squish
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
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<-SQL.squish
    CREATE OR REPLACE FUNCTION generate_patient_secure_id()
      /*
        Generates and returns a unique base 58 token 24 characters long for use as a secure_id on
        the Renalware patients table. If the generated token is in use already (very unlikely) it
        retries until a unique one is generated.
        Example usage:
          select generate_patient_secure_id #=> 0KPNXf4X5x1o6O4mXWE5MC9H
        TC 8.6.2017
      */
      RETURNS varchar AS $$
      DECLARE
      new_secure_id varchar;
      BEGIN
      LOOP
        new_secure_id := generate_secure_id(24);
        EXIT WHEN NOT EXISTS(select 1 from patients where 'secure_id' = new_secure_id);
        RAISE NOTICE 'The generated secure_id % was already in use - now generating another', new_secure_id;
      END LOOP;
      RETURN new_secure_id;
      END
      $$ LANGUAGE plpgsql;
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    ActiveRecord::Base.connection.execute(
      "DROP FUNCTION IF EXISTS generate_secure_id(integer); \
       DROP FUNCTION IF EXISTS generate_patient_secure_id();"
    )
  end
end
