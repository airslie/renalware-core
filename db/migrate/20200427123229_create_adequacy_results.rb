class CreateAdequacyResults < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :pd_adequacy_results do |t|
        t.references :patient, null: false, foreign_key: true

        # The first set are inputs after seeing the patient
        t.date :performed_on, null: false
        t.integer :dial_24_vol_in
        t.integer :dial_24_vol_out
        t.boolean :dial_24_missing, null: false, default: false
        t.integer :urine_24_vol
        t.boolean :urine_24_missing, null: false, default: false

        # Blood results back from the lab
        t.float :serum_urea
        t.float :serum_creatinine
        t.float :plasma_glc
        t.float :serum_ab

        # Dialysate results back from the lab
        t.float :dialysate_urea
        t.float :dialysate_creatinine
        t.float :dialysate_glu
        t.float :dialysate_na
        t.float :dialysate_protein

        # Urine results back from the lab
        t.float :urine_urea
        t.float :urine_creatinine
        t.float :urine_na
        t.float :urine_k

        # Calculations
        t.float :total_creatinine_clearance
        t.float :pertitoneal_creatinine_clearance
        t.float :renal_creatinine_clearance
        t.float :total_ktv
        t.float :pertitoneal_ktv
        t.float :renal_ktv
        t.float :dietry_protein_intake

        t.datetime :deleted_at, index: true
        t.references :created_by, index: true, null: false
        t.references :updated_by, index: true, null: false
        t.timestamps null: false
      end

      add_foreign_key :pd_adequacy_results, :users, column: :created_by_id
      add_foreign_key :pd_adequacy_results, :users, column: :updated_by_id
    end
  end
end
