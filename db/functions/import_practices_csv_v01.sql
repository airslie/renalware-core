CREATE OR REPLACE FUNCTION renalware.import_practices_csv(file text) RETURNS void AS $$
  BEGIN
  /*
  Imports a practices.csv file created by parsing out an HSCOrgRefData_Full_xxxxx.xml file.
  */
  DROP TABLE IF EXISTS tmp_practices;

  CREATE TEMP TABLE tmp_practices (
    code text NOT NULL,
    name text NOT NULL,
    tel text,
    street_1 text,
    street_2 text,
    street_3 text,
    town text,
    county text,
    postcode text NOT NULL,
    region text,
    country_id integer,
    active text NOT NULL,
    CONSTRAINT tmp_practices_pkey PRIMARY KEY (code)
  );

  /* Import the CSV file into tmp_practices, ignoring the first row which is a header */
  EXECUTE format ('COPY tmp_practices FROM %L DELIMITER %L CSV HEADER', file, ',');

  /* Upsert practices */
  WITH data(
      code,
      name,
      telephone,
      street_1,
      street_2,
      street_3,
      town,
      county,
      postcode,
      region,
      country_id,
      active)
    AS (select * from tmp_practices)
    , practice_changes AS (
        INSERT INTO patient_practices (code, name, telephone, created_at, updated_at)
        SELECT code, name, telephone, clock_timestamp(), clock_timestamp()
        FROM data
        ON CONFLICT (code) DO UPDATE
          SET
            name = excluded.name,
            telephone = excluded.telephone,
            updated_at = excluded.updated_at
          RETURNING code, id
      )

  /* Upsert practice addresses */
  INSERT INTO addresses (
    addressable_type,
    addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    region,
    country_id,
    created_at,
    updated_at)
  SELECT
    'Renalware::Patients::Practice',
    practice_changes.id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    region,
    country_id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
    FROM data join practice_changes using(code)
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET
    street_1 = excluded.street_1,
    street_2 = excluded.street_2,
    street_3 = excluded.street_3,
    town = excluded.town,
    county = excluded.county,
    postcode = excluded.postcode,
    region = excluded.region,
    country_id = excluded.country_id,
    updated_at = clock_timestamp();

  /* Update the deleted_at column of any practices which do not have an Active status_code */
  UPDATE patient_practices AS p
  SET deleted_at = CURRENT_TIMESTAMP
  FROM tmp_practices AS tp
  WHERE p.code = tp.code AND tp.active = 'false';

  /* Set deleted_at tp NULL for active practices */
  UPDATE patient_practices AS p
  SET deleted_at = NULL
  FROM tmp_practices AS tp
  WHERE p.code = tp.code AND tp.active != 'false';

  DROP TABLE tmp_practices;

  END;
  $$ LANGUAGE plpgsql;
