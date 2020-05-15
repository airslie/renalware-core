class CreatePDPETDextroseConcentrations < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :pd_pet_dextrose_concentrations do |t|
        t.string :name, null: false, index: { unique: true }
        t.float :value, null: false, index: { unique: true }
        t.boolean :hidden, null: false, default: false
        t.integer :position, null: false, default: 0
        t.timestamps null: false
      end
    end
  end
end
