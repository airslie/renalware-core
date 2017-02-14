class CreatePathologyRequestsDrugCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_requests_drug_categories do |t|
      t.string :name, null: false, unique: true
    end
  end
end
