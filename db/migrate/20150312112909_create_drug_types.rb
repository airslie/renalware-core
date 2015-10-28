class CreateDrugTypes < ActiveRecord::Migration
  def change
    create_table :drug_types do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: :index
      t.timestamps null: false
    end
  end
end
