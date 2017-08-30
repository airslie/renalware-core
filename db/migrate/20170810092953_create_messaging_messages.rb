class CreateMessagingMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messaging_messages do |t|
      t.text :body, null: false
      t.string :subject, null: false, index: true
      t.boolean :urgent, null: false, default: false
      t.datetime :sent_at, null: false
      t.references :patient, index: true, null: false, foreign_key: true
      t.references :author, index: true, null: false, foreign_key: { to_table: :users }
      t.timestamps null: false
    end
  end
end
