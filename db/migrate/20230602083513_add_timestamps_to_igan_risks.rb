class AddTimestampsToIganRisks < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      within_renalware_schema do
        change_table :clinical_igan_risks do |t|
          t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
          t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
          t.timestamps null: false
        end
      end
    end
  end
end
