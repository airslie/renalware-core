-- Create the trigger which will call our function every time a row in hd_sessions
-- is inserted or updated
DROP TRIGGER IF EXISTS update_hd_sessions_trigger ON renalware.hd_sessions;
CREATE TRIGGER update_hd_sessions_trigger
  before INSERT or update ON renalware.hd_sessions FOR EACH ROW
  EXECUTE PROCEDURE renalware.update_hd_sessions_from_trigger();
