CREATE OR REPLACE FUNCTION renalware.import_feed_gps() RETURNS void AS $$
BEGIN
  INSERT INTO renalware.patient_primary_care_physicians
    (code, name, telephone, practitioner_type, ods_managed, created_at, updated_at)
  SELECT
    code,
    name,
    telephone,
    'GP',
    true,
    clock_timestamp(),
    clock_timestamp()
  FROM renalware.feed_gps
  WHERE code <> 'G9999998'
  ON CONFLICT (code) DO UPDATE
    SET name = excluded.name,
        telephone = excluded.telephone,
        ods_managed = true,
        updated_at = excluded.updated_at
    WHERE (patient_primary_care_physicians.name,
           patient_primary_care_physicians.telephone,
           patient_primary_care_physicians.ods_managed)
      IS DISTINCT FROM
          (excluded.name,
           excluded.telephone,
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
     created_at,
     updated_at)
  SELECT
    'Renalware::Patients::PrimaryCarePhysician',
    gps.id,
    feed.street_1,
    feed.street_2,
    feed.street_3,
    feed.town,
    feed.county,
    feed.postcode,
    clock_timestamp(),
    clock_timestamp()
  FROM renalware.feed_gps feed
  INNER JOIN renalware.patient_primary_care_physicians gps ON gps.code = feed.code
  WHERE feed.code <> 'G9999998'
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET street_1 = excluded.street_1,
        street_2 = excluded.street_2,
        street_3 = excluded.street_3,
        town = excluded.town,
        county = excluded.county,
        postcode = excluded.postcode,
        updated_at = excluded.updated_at
    WHERE (addresses.street_1,
           addresses.street_2,
           addresses.street_3,
           addresses.town,
           addresses.county,
           addresses.postcode)
      IS DISTINCT FROM
          (excluded.street_1,
           excluded.street_2,
           excluded.street_3,
           excluded.town,
           excluded.county,
           excluded.postcode);

  UPDATE renalware.patient_primary_care_physicians physicians
  SET deleted_at = CASE WHEN feed.status = 'ACTIVE' THEN NULL ELSE clock_timestamp() END,
      updated_at = clock_timestamp()
  FROM renalware.feed_gps feed
  WHERE physicians.code = feed.code
    AND feed.code <> 'G9999998'
    AND (
      (feed.status = 'ACTIVE' AND physicians.deleted_at IS NOT NULL)
      OR (feed.status <> 'ACTIVE' AND physicians.deleted_at IS NULL)
    );
END;
$$ LANGUAGE plpgsql;
