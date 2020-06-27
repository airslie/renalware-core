CREATE OR REPLACE FUNCTION update_pathology_observations_nresult_from_trigger() RETURNS TRIGGER AS $body$
DECLARE
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    NEW.nresult = convert_to_float(NEW.result, NULL);
  END IF;
  RETURN NEW ;
END $body$ LANGUAGE plpgsql;

COMMENT ON FUNCTION update_pathology_observations_nresult_from_trigger() IS
'Tries to coerce the result column into the nresult column as a float.
Sets nresult to NULL if result is eg text and cannot be coerced.
nresult is a performance optimisation useful for instance in graphing';
