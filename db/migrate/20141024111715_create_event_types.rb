class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string :name, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
