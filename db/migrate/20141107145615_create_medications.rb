class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.references :patient,           null: false, foreign_key: true
      t.references :medicatable,       polymorphic: true, index: true, null: false
      t.references :treatable,         polymorphic: true, index: true
      t.string :dose,                  null: false
      t.references :medication_route,  null: false, foreign_key: true
      t.string :frequency,             null: false
      t.text :notes
      t.date :start_date,              null: false
      t.date :end_date
      t.integer :provider,             null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
