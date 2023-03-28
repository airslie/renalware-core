class CreateDrugUnitOfMeasures < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :drug_unit_of_measures do |t|
        t.string :name
        t.string :code, null: false, index: { unique: true }

        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
