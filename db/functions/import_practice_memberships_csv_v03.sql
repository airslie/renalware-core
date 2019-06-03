CREATE OR REPLACE FUNCTION renalware.import_practice_memberships_csv(file text) RETURNS void
  AS $$
  BEGIN

  DROP TABLE IF EXISTS copied_memberships;
  CREATE TEMP TABLE copied_memberships (
    gp_code text NOT NULL,
    practice_code text NOT NULL,
    unused3 text,
    joined_on text,
    left_on text,
    unused7 text
  );

  -- Import the CSV file into copied_memberships - note there is no CSV header in this file
  EXECUTE format ('COPY copied_memberships FROM %L DELIMITER %L CSV ', file, ',');

  DROP TABLE IF EXISTS tmp_memberships;
  CREATE TEMP TABLE tmp_memberships AS
    SELECT
      C.gp_code,
      C.practice_code,
      case C.joined_on when '' then NULL else C.joined_on::date end,
      case C.left_on when '' then NULL else C.left_on::date end,
      patient_primary_care_physicians.id primary_care_physician_id,
      patient_practices.id as practice_id
      from copied_memberships C
      INNER JOIN patient_practices on patient_practices.code = C.practice_code
      INNER JOIN patient_primary_care_physicians on patient_primary_care_physicians.code = C.gp_code;

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
  FROM tmp_memberships
  ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

  -- However we need to ensure the joined_on left_on and active columns are up to date as these
  -- were recently added
  UPDATE renalware.patient_practice_memberships AS M
  SET
    joined_on = T.joined_on,
    left_on = T.left_on,
    active = case when T.left_on is null then true else false end
  FROM tmp_memberships T
  WHERE T.practice_id = M.practice_id  AND T.primary_care_physician_id = M.primary_care_physician_id;

  -- Mark as deleted any memberships not in the latest uploaded data set - ie those gps have retired or moved on
  UPDATE patient_practice_memberships mem
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE NOT EXISTS (select 1 FROM tmp_memberships tmem
    WHERE tmem.practice_id = mem.practice_id AND tmem.primary_care_physician_id = mem.primary_care_physician_id);

  DROP TABLE IF EXISTS copied_memberships;
  DROP TABLE IF EXISTS tmp_memberships;
END;
$$ LANGUAGE plpgsql;
