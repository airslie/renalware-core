class CreateDrugForms < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_forms do |t|
        t.string :name
        t.string :code, null: false, index: { unique: true }

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      safety_assured do
        add_reference :medication_prescriptions, :form,
                      foreign_key: { to_table: :drug_forms }
      end
    end
  end
end
