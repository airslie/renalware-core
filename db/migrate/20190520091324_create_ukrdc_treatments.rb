class CreateUKRDCTreatments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :ukrdc_treatments do |t|
        t.references :patient, foreign_key: true, index: true, null: false
        t.references :clinician, foreign_key: { to_table: :users }, index: true, null: true
        t.references :modality_code, foreign_key: { to_table: :ukrdc_modality_codes }, index: true, null: false
        t.date :started_on, null: false
        t.date :ended_on
        t.timestamps null: false
      end
    end
  end
end
