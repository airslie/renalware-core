class CreateVirologyVaccinationTypes < ActiveRecord::Migration[5.2]
  within_renalware_schema do
    def change
      create_table :virology_vaccination_types do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false, index: { unique: true }
        t.integer :position, null: false, default: 0
        t.datetime :deleted_at
        t.timestamps null: false
      end
    end
  end
end
