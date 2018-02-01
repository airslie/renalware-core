-- Create the trigger which will call out function every time a row in pathology_observations
-- is inserted or updated
DROP TRIGGER IF EXISTS update_current_observation_set_trigger ON pathology_observations;
CREATE TRIGGER update_current_observation_set_trigger
  AFTER INSERT OR UPDATE
  ON pathology_observations
  FOR EACH ROW EXECUTE PROCEDURE update_current_observation_set_from_trigger();
