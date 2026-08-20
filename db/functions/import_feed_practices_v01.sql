CREATE OR REPLACE FUNCTION renalware.import_feed_practices() RETURNS void AS $$
BEGIN
  INSERT INTO renalware.patient_practices
    (code, name, telephone, active, ods_managed, created_at, updated_at)
  SELECT
    code,
    name,
    telephone,
    status = 'ACTIVE',
    true,
    clock_timestamp(),
    clock_timestamp()
  FROM renalware.feed_practices
  ON CONFLICT (code) DO UPDATE
    SET name = excluded.name,
        telephone = excluded.telephone,
        active = excluded.active,
        ods_managed = true,
        updated_at = excluded.updated_at
    WHERE (patient_practices.name,
           patient_practices.telephone,
           patient_practices.active,
           patient_practices.ods_managed)
      IS DISTINCT FROM
          (excluded.name,
           excluded.telephone,
           excluded.active,
           excluded.ods_managed);

  INSERT INTO renalware.addresses
    (addressable_type,
     addressable_id,
     street_1,
     street_2,
     street_3,
     town,
     county,
     postcode,
     country_id,
     created_at,
     updated_at)
  SELECT
    'Renalware::Patients::Practice',
    practices.id,
    feed.street_1,
    feed.street_2,
    feed.street_3,
    feed.town,
    feed.county,
    feed.postcode,
    countries.id,
    clock_timestamp(),
    clock_timestamp()
  FROM renalware.feed_practices feed
  INNER JOIN renalware.patient_practices practices ON practices.code = feed.code
  CROSS JOIN (
    SELECT id FROM renalware.system_countries WHERE alpha2 = 'GB' LIMIT 1
  ) countries
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET street_1 = excluded.street_1,
        street_2 = excluded.street_2,
        street_3 = excluded.street_3,
        town = excluded.town,
        county = excluded.county,
        postcode = excluded.postcode,
        country_id = excluded.country_id,
        updated_at = excluded.updated_at
    WHERE (addresses.street_1,
           addresses.street_2,
           addresses.street_3,
           addresses.town,
           addresses.county,
           addresses.postcode,
           addresses.country_id)
      IS DISTINCT FROM
          (excluded.street_1,
           excluded.street_2,
           excluded.street_3,
           excluded.town,
           excluded.county,
           excluded.postcode,
           excluded.country_id);
END;
$$ LANGUAGE plpgsql;
