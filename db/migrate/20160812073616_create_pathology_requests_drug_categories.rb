class CreatePathologyRequestsDrugCategories < ActiveRecord::Migration
  def change
    create_table :pathology_requests_drug_categories do |t|
      t.string :name, null: false, unique: true
    end
  end
end
