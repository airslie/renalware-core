class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :date_time
      t.string :event_type
      t.string :description
      t.text :notes
      t.timestamps
    end
  end
end
