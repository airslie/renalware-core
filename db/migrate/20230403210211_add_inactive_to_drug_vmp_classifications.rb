class AddInactiveToDrugVMPClassifications < ActiveRecord::Migration[7.0]
  def change
    add_column :drug_vmp_classifications, :inactive, :boolean, default: false
  end
end
