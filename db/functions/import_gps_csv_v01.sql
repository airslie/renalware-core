CREATE OR REPLACE FUNCTION renalware.import_gps_csv(file text) RETURNS void
  AS $$
  BEGIN
  -- Imports a egpcur.csv.csv file created from ODS.
  -- Returns counts of changed (insert/updated) and (soft) deleted rows.

  DROP TABLE IF EXISTS tmp_gps_copy;

  -- Create a tmp table to hold the ODS-defined standard 27 field format into which we will insert out CSV data
  CREATE TEMP TABLE tmp_gps_copy (
  code text NOT NULL,
  name text NOT NULL,
  unused3 text,
  unused4 text,
  street_1 text,
  street_2 text,
  street_3 text,
  town text,
  county text,
  postcode text,
  unused11 text,
  unused12 text,
  status text, -- A = Active B = Retired C = Closed P = Proposed
  unused14 text,
  unused15 text,
  unused16 text,
  unused17 text,
  telephone text,
  unused19 text,
  unused20 text,
  unused21 text,
  amended_record_indicator text,
  unused23 text,
  unused24 text,
  unused25 text,
  unused26 text,
  unused27 text,
  CONSTRAINT tmp_gps_pkey PRIMARY KEY (code)
  );

  -- Import the CSV file into tmp_practices - note there is no CSV header in this file
  EXECUTE format ('COPY tmp_gps_copy FROM %L DELIMITER %L CSV ', file, ',');

  DROP TABLE IF EXISTS tmp_gps;
  CREATE TEMP TABLE tmp_gps AS SELECT
    code,
    name,
    telephone,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    left(status,1) as status from tmp_gps_copy ;
  ALTER TABLE tmp_gps ADD PRIMARY KEY (code);

RAISE NOTICE 'Calling cs_create_job(%)', (select status from tmp_gps limit 1);

  -- Upsert GPs
  WITH
   data AS (select * from  tmp_gps),
   gp_changes AS (
    INSERT INTO renalware.patient_primary_care_physicians (code, name, telephone, practitioner_type, created_at, updated_at)
    SELECT code, name, telephone, 'GP', clock_timestamp(), clock_timestamp()
    FROM data
    ON CONFLICT (code) DO UPDATE
      SET
       telephone = excluded.telephone,
       name = excluded.name,
       updated_at = excluded.updated_at
      where (patient_primary_care_physicians.telephone) is distinct from (excluded.telephone)
      RETURNING code, id
     )

  -- Upsert GP addresses
  INSERT INTO renalware.addresses (
    addressable_type,
    addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    created_at,
    updated_at)
  SELECT
    'Renalware::Patients::PrimaryCarePhysician' as addressable_type,
    gps.id as addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
    FROM data join patient_primary_care_physicians gps using(code)
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET
    street_1 = excluded.street_1,
    street_2 = excluded.street_2,
    street_3 = excluded.street_3,
    town = excluded.town,
    county = excluded.county,
    postcode = excluded.postcode,
    updated_at = clock_timestamp()
    where (addresses.street_1, addresses.street_2, addresses.street_3)
    is distinct from (excluded.street_1, excluded.street_2, excluded.street_3);

  --GET DIAGNOSTICS changed_count = ROW_COUNT;

  -- Update the deleted_at column of any gps which do not have an Active status_code
  UPDATE renalware.patient_primary_care_physicians AS p
  SET deleted_at = CURRENT_TIMESTAMP
  FROM tmp_gps AS tp
  WHERE p.code = tp.code AND tp.status IN ('C', 'P', 'B');

  -- Un-delete any previously deleted GPs
  UPDATE renalware.patient_primary_care_physicians AS gp
  SET deleted_at = NULL
  FROM tmp_gps
  WHERE gp.code = tmp_gps.code AND tmp_gps.status IN ('A') AND gp.code NOT IN ('A');

  --GET DIAGNOSTICS deleted_count = ROW_COUNT;
  --select changed_count, deleted_count;
  END;
 $$ LANGUAGE plpgsql;
