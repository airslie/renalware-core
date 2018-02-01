class CreateTriggerToPreprocessHL7Msg < ActiveRecord::Migration[5.1]
  def up
    load_function("preprocess_hl7_message_v01.sql")
    load_trigger("feed_messages_preprocessing_trigger_v01.sql")
  end

  def down
    connection.execute("
      drop trigger if exists feed_messages_preprocessing_trigger on delayed_jobs;
      drop function if exists preprocess_hl7_message();"
    )
  end
end
