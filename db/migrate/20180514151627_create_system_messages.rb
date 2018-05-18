class CreateSystemMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :system_messages do |t|
      t.string :title, null: true
      t.text :body, null: false
      t.integer :message_type, null: false, default: 0
      t.string :severity
      t.datetime :display_from, null: false
      t.datetime :display_until
      t.timestamps null: false
    end
  end
end
