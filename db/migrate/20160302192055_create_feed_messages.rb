class CreateFeedMessages < ActiveRecord::Migration
  def change
    create_table :feed_messages do |t|
      t.string :event_code, null: false
      t.text :body, null: false
      t.timestamps null: false
    end
  end
end
