class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.references :patient,           null: false, foreign_key: true
      t.references :drug,              null: false, foreign_key: true
      t.references :treatable,         polymorphic: true, index: true, null: false
      t.string :dose,                  null: false
      t.references :medication_route,  null: false, foreign_key: true
      t.string :route_description
      t.string :frequency,             null: false
      t.text :notes
      t.date :prescribed_on,              null: false
      t.date :terminated_on
      t.integer :provider,             null: false
      t.string :state, null: false, default: "current"
      t.timestamps null: false
    end
  end
end
