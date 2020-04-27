class CreateAdequacyResults < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :pd_adequacy_results do |t|
        t.references :patient, null: false, foreign_key: true

        # The first set are inputs after seeing the patient
        t.date :performed_on, null: false
        t.decimal :dial_24_vol_in, scale: 2, precision: 15
        t.decimal :dial_24_vol_out, scale: 2, precision: 15
        t.boolean :dial_24_missing, null: false, default: false
        t.decimal :urine_24_vol, scale: 2, precision: 15
        t.boolean :urine_24_missing, null: false, default: false

        t.references :created_by, index: true, null: false
        t.references :updated_by, index: true, null: false
        t.timestamps null: false
      end

      add_foreign_key :pd_adequacy_results, :users, column: :created_by_id
      add_foreign_key :pd_adequacy_results, :users, column: :updated_by_id
    end
  end
end
