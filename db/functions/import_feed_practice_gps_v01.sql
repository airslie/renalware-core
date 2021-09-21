CREATE OR REPLACE FUNCTION renalware.import_feed_practice_gps() RETURNS void
  AS $$
  BEGIN

  -- 1. Update feed_practice_gps with the correct pcp and prac ids
  UPDATE feed_practice_gps x
  SET primary_care_physician_id = ppm.id
  FROM patient_primary_care_physicians AS ppm WHERE ppm.code = x.gp_code;

  UPDATE feed_practice_gps x
  SET practice_id = pp.id
  FROM patient_practices AS pp WHERE pp.code = x.practice_code;

  -- Insert any new memberships, ignoring any conflicts where the
  -- practice_id + primary_care_physician_id already exists
  INSERT INTO renalware.patient_practice_memberships
    (practice_id, primary_care_physician_id, joined_on, left_on, active, created_at, updated_at)
  SELECT
    practice_id,
    primary_care_physician_id,
    joined_on,
    left_on,
    case when left_on is null then true else false end,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM feed_practice_gps
  ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

  -- However we need to ensure the joined_on left_on and active columns are up to date as these
  -- were recently added
  UPDATE renalware.patient_practice_memberships AS M
  SET
    joined_on = T.joined_on,
    left_on = T.left_on,
    active = case when T.left_on is null then true else false end
  FROM feed_practice_gps T
  WHERE T.practice_id = M.practice_id  AND T.primary_care_physician_id = M.primary_care_physician_id;

  -- Mark as deleted any memberships not in the latest uploaded data set - ie those gps have retired or moved on
  UPDATE patient_practice_memberships mem
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE NOT EXISTS (select 1 FROM feed_practice_gps tmem
    WHERE tmem.practice_id = mem.practice_id AND tmem.primary_care_physician_id = mem.primary_care_physician_id);

END;
$$ LANGUAGE plpgsql;
