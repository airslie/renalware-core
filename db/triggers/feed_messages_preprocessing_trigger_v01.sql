CREATE TRIGGER feed_messages_preprocessing_trigger
  BEFORE INSERT
  ON delayed_jobs
  FOR EACH ROW
  EXECUTE PROCEDURE preprocess_hl7_message();
