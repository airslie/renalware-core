class AddSentAtToFeedRawHL7Messages < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :feed_raw_hl7_messages, :sent_at, :datetime
        add_index :feed_raw_hl7_messages, :sent_at
      end

      reversible do |dir|
        dir.up do
          connection.execute("drop function if exists renalware.insert_raw_hl7_message")
          load_function("insert_raw_hl7_message_v02.sql")
        end
        dir.down do
          connection.execute("drop function if exists renalware.insert_raw_hl7_message")
          load_function("insert_raw_hl7_message_v01.sql")
        end
      end
    end
  end
end
