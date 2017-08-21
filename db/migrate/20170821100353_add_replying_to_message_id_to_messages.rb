class AddReplyingToMessageIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messaging_messages,
               :replying_to_message_id,
               :integer,
               index: true,
               null: true
    add_foreign_key :messaging_messages,
                    :messaging_messages,
                    column: :replying_to_message_id
  end
end
