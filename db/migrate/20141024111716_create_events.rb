class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :patient,   null: false, foreign_key: true
      t.datetime :date_time,   null: false
      t.integer :event_type_id
      t.string :description
      t.text :notes
      t.timestamps
    end
  end
end
