class RenameFeedMessageEventCode < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      safety_assured do
        change_column_null :feed_messages, :event_code, true
        rename_column :feed_messages, :event_code, :event_code_deprecated
      end
    end
  end
end
