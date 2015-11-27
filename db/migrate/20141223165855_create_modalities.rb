class CreateModalities < ActiveRecord::Migration
  def change
    create_table :modalities do |t|
      t.references :patient,      null: false, foreign_key: true
      t.references :description,  null: false, foreign_key: true
      t.references :reason_id,    foreign_key: true
      t.string :modal_change_type
      t.text :notes
      t.date :started_on,         null: false
      t.date :ended_on
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
