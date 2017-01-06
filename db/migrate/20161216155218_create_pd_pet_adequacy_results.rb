class CreatePDPETAdequacyResults < ActiveRecord::Migration
  def change
    create_table :pd_pet_adequacy_results do |t|
      t.references :patient, null: false, foreign_key: true
      t.date :pet_date
      t.string :pet_type
      t.decimal :pet_duration, scale: 1, precision: 8
      t.integer :pet_net_uf
      t.decimal :dialysate_creat_plasma_ratio, scale: 2, precision: 8
      t.decimal :dialysate_glucose_start, scale: 1, precision: 8
      t.decimal :dialysate_glucose_end, scale: 1, precision: 8
      t.date :adequacy_date
      t.decimal :ktv_total, scale: 2, precision: 8
      t.decimal :ktv_dialysate, scale: 2, precision: 8
      t.decimal :ktv_rrf, scale: 2, precision: 8
      t.integer :crcl_total
      t.integer :crcl_dialysate
      t.integer :crcl_rrf
      t.integer :daily_uf
      t.integer :daily_urine
      t.date :date_rff
      t.integer :creat_value
      t.decimal :dialysate_effluent_volume, scale: 2, precision: 8
      t.date :date_creat_clearance
      t.date :date_creat_value
      t.decimal :urine_urea_conc, scale: 1, precision: 8
      t.integer :urine_creat_conc

      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :pd_pet_adequacy_results, :users, column: :created_by_id
    add_foreign_key :pd_pet_adequacy_results, :users, column: :updated_by_id
  end
end
