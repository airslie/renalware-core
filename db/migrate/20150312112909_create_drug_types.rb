class CreateDrugTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :drug_types do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: :index
      t.timestamps null: false
    end
  end
end
