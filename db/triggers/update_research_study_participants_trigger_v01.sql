-- Create the trigger which will call out function every time a row in pathology_observations
-- is inserted or updated
DROP TRIGGER IF EXISTS update_research_study_participants_trigger ON renalware.research_study_participants;
CREATE TRIGGER update_research_study_participants_trigger
  BEFORE INSERT ON renalware.research_study_participants FOR EACH ROW
  EXECUTE PROCEDURE renalware.update_research_study_participants_from_trigger();
