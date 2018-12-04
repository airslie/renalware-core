class AddCreatedAtToDelayedJobsInHL7TrigFn < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function("preprocess_hl7_message_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("preprocess_hl7_message_v01.sql")
    end
  end
end
