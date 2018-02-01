class AddCreatedAtToDelayedJobsInHL7TrigFn < ActiveRecord::Migration[5.1]
  def up
    load_function("preprocess_hl7_message_v02.sql")
  end

  def down
    load_function("preprocess_hl7_message_v01.sql")
  end
end
