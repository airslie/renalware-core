class CreateRenalProfile < ActiveRecord::Migration
  def change
    create_table :renal_profiles do |t|
      t.references :patient, null: false, foreign_key: true
      t.date :esrf_on
      t.date :first_seen_on
      t.float :weight_at_esrf
      t.references :prd_description
      t.string :smoking_status
      t.date :comorbidities_updated_on
      t.jsonb :document
      t.timestamps null: false
    end

    add_index :renal_profiles, :document, using: :gin
    add_foreign_key :renal_profiles, :renal_prd_descriptions, column: :prd_description_id
  end
end
