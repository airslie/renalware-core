class CreateFeedRawHL7Messages < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :feed_raw_hl7_messages do |t|
        t.string :body

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
