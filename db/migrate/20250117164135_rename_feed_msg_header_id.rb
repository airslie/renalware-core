class RenameFeedMsgHeaderId < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      safety_assured do
        rename_column :feed_sausages, :header_id, :message_control_id
        add_index :feed_sausages, :message_control_id, unique: true
      end
    end
  end
end
