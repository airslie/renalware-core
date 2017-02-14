class RenameReadCodeToCodeOnPDOrganismCodes < ActiveRecord::Migration[4.2]
  def change
    rename_column :pd_organism_codes, :read_code, :code
  end
end
