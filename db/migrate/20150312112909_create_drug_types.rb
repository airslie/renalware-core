class CreateDrugTypes < ActiveRecord::Migration
  def change
    create_table :drug_types do |t|

      t.timestamps null: false
    end
  end
end
