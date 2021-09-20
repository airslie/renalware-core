CREATE OR REPLACE FUNCTION renalware.import_feed_gps() RETURNS void
  AS $$
  BEGIN

  -- Upsert GPs
  WITH
   data AS (select * from feed_gps),
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
  FROM feed_gps AS tp
  WHERE p.code = tp.code AND tp.status IN ('C', 'P', 'B');

  -- Un-delete any previously deleted GPs
  UPDATE renalware.patient_primary_care_physicians AS gp
  SET deleted_at = NULL
  FROM feed_gps
  WHERE gp.code = feed_gps.code AND feed_gps.status IN ('A') AND gp.code NOT IN ('A');

  --GET DIAGNOSTICS deleted_count = ROW_COUNT;
  --select changed_count, deleted_count;
  END;
 $$ LANGUAGE plpgsql;
