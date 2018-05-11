class AddMessageHashMessagingMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :feed_messages, :body_hash, :text, null: true
    add_index :feed_messages, :body_hash, unique: true
  end
end
