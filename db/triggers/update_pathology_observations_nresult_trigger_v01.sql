-- Create the trigger which will call out function every time a row in pathology_observations
-- is inserted or updated
DROP TRIGGER IF EXISTS update_pathology_observations_nresult_trigger ON pathology_observations;
CREATE TRIGGER update_pathology_observations_nresult_trigger
  BEFORE INSERT OR UPDATE
  ON pathology_observations
  FOR EACH ROW EXECUTE PROCEDURE update_pathology_observations_nresult_from_trigger();

COMMENT ON TRIGGER update_pathology_observations_nresult_trigger ON pathology_observations IS
'When a row is updated or inserted into pathology_observations, call a function to try and
coerce the result into a new float column which can be more easily consumed for graphing etc';
