CREATE OR REPLACE FUNCTION renalware.import_feed_practice_gps() RETURNS void AS $$
DECLARE
  unknown_gp_count integer;
  unknown_gp_codes text;
  unknown_practice_count integer;
  unknown_practice_codes text;
BEGIN
  DELETE FROM renalware.feed_practice_gps
  WHERE gp_code = 'G9999998';

  UPDATE renalware.feed_practice_gps feed
  SET primary_care_physician_id = physicians.id
  FROM renalware.patient_primary_care_physicians physicians
  WHERE physicians.code = feed.gp_code;

  UPDATE renalware.feed_practice_gps feed
  SET practice_id = practices.id
  FROM renalware.patient_practices practices
  WHERE practices.code = feed.practice_code;

  SELECT COUNT(DISTINCT gp_code)
  INTO unknown_gp_count
  FROM renalware.feed_practice_gps
  WHERE primary_care_physician_id IS NULL;

  SELECT string_agg(gp_code, ', ' ORDER BY gp_code)
  INTO unknown_gp_codes
  FROM (
    SELECT DISTINCT gp_code
    FROM renalware.feed_practice_gps
    WHERE primary_care_physician_id IS NULL
    ORDER BY gp_code
    LIMIT 5
  ) unknown_gps;

  SELECT COUNT(DISTINCT practice_code)
  INTO unknown_practice_count
  FROM renalware.feed_practice_gps
  WHERE practice_id IS NULL;

  SELECT string_agg(practice_code, ', ' ORDER BY practice_code)
  INTO unknown_practice_codes
  FROM (
    SELECT DISTINCT practice_code
    FROM renalware.feed_practice_gps
    WHERE practice_id IS NULL
    ORDER BY practice_code
    LIMIT 5
  ) unknown_practices;

  IF unknown_gp_count > 0 OR unknown_practice_count > 0 THEN
    RAISE EXCEPTION USING MESSAGE = format(
      'Practice membership feed contains %s unknown GP code(s) [%s] and ' ||
      '%s unknown practice code(s) [%s]',
      unknown_gp_count,
      COALESCE(unknown_gp_codes, 'none'),
      unknown_practice_count,
      COALESCE(unknown_practice_codes, 'none')
    );
  END IF;

  WITH latest_memberships AS (
    SELECT DISTINCT ON (practice_id, primary_care_physician_id)
      practice_id,
      primary_care_physician_id,
      joined_on,
      left_on
    FROM renalware.feed_practice_gps
    WHERE practice_id IS NOT NULL AND primary_care_physician_id IS NOT NULL
    ORDER BY
      practice_id,
      primary_care_physician_id,
      joined_on DESC NULLS LAST,
      left_on DESC NULLS LAST
  )
  INSERT INTO renalware.patient_practice_memberships
    (practice_id,
     primary_care_physician_id,
     joined_on,
     left_on,
     active,
     ods_managed,
     deleted_at,
     created_at,
     updated_at)
  SELECT
    practice_id,
    primary_care_physician_id,
    joined_on,
    left_on,
    (left_on IS NULL OR left_on >= CURRENT_DATE) AND EXISTS (
      SELECT 1
      FROM renalware.patient_primary_care_physicians physicians
      WHERE physicians.id = latest_memberships.primary_care_physician_id
        AND physicians.deleted_at IS NULL
    ),
    true,
    NULL,
    clock_timestamp(),
    clock_timestamp()
  FROM latest_memberships
  ON CONFLICT (practice_id, primary_care_physician_id) DO UPDATE
    SET joined_on = excluded.joined_on,
        left_on = excluded.left_on,
        active = excluded.active,
        ods_managed = true,
        deleted_at = NULL,
        updated_at = excluded.updated_at
    WHERE (patient_practice_memberships.joined_on,
           patient_practice_memberships.left_on,
           patient_practice_memberships.active,
           patient_practice_memberships.ods_managed,
           patient_practice_memberships.deleted_at)
      IS DISTINCT FROM
          (excluded.joined_on,
           excluded.left_on,
           excluded.active,
           excluded.ods_managed,
           excluded.deleted_at);

  UPDATE renalware.patient_practice_memberships membership
  SET deleted_at = clock_timestamp(),
      active = false,
      updated_at = clock_timestamp()
  WHERE membership.ods_managed = true
    AND membership.default_gp = false
    AND membership.deleted_at IS NULL
    AND NOT EXISTS (
      SELECT 1
      FROM renalware.patient_primary_care_physicians physicians
      WHERE physicians.id = membership.primary_care_physician_id
        AND physicians.code = 'G9999998'
    )
    AND NOT EXISTS (
      SELECT 1
      FROM renalware.feed_practice_gps feed
      WHERE feed.primary_care_physician_id = membership.primary_care_physician_id
        AND feed.practice_id = membership.practice_id
    );
END;
$$ LANGUAGE plpgsql;
