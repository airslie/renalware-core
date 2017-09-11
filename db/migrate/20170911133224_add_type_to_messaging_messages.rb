class AddTypeToMessagingMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messaging_messages, :type, :string, null: false
    add_index :messaging_messages, :type
  end
end
