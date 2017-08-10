class CreateMessagingReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :messaging_receipts do |t|
      t.references :message, index: true, null: false, foreign_key: { to_table: :messaging_messages }
      t.references :recipient, index: true, null: false, foreign_key: { to_table: :users }
      t.datetime :read_at, null: true, index: true
    end
  end
end
