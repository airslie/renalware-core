CREATE OR REPLACE FUNCTION renalware.import_feed_practice_gps() RETURNS void
  AS $$
  BEGIN

  /*
    1.
    Update the temporary feed_practice_gps with the correct pcp and prac ids.
    I supopse we could do this in Rails.
  */
  UPDATE feed_practice_gps F
    SET primary_care_physician_id = P.id
    FROM patient_primary_care_physicians AS P WHERE P.code = F.gp_code;

  UPDATE feed_practice_gps F
    SET practice_id = P.id
    FROM patient_practices AS P WHERE P.code = F.practice_code;

  /*
    2.
    Add any new membership rows (ignoring errors if the row already exists)
  */
  INSERT INTO renalware.patient_practice_memberships
    (practice_id, primary_care_physician_id, joined_on, left_on, active, created_at, updated_at)
  SELECT
    practice_id,
    primary_care_physician_id,
    joined_on,
    left_on,
    case when left_on is null then true else false end, --active
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM feed_practice_gps
  where practice_id is not null and primary_care_physician_id is not null
  ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

  /*
    3.
    Mark as deleted any memberships not in the latest uploaded data set
    as these gps have retired or moved on.
  */
  UPDATE patient_practice_memberships M
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE NOT EXISTS (
      select 1 FROM feed_practice_gps T
      where T.primary_care_physician_id = M.primary_care_physician_id
      and T.practice_id = M.practice_id
    );

END;
$$ LANGUAGE plpgsql;
