class CreateClinicVisits < ActiveRecord::Migration
  def change
    create_table :clinic_visits do |t|
      t.belongs_to :patient, index: true
      t.datetime :date, null: false
      t.float :height
      t.float :weight
      t.integer :systolic_bp
      t.integer :diastolic_bp
      t.string :urine_blood
      t.string :urine_protein
      t.text :notes
      t.timestamps null: false
    end
  end
end
