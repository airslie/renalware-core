class RenameReadCodeToCodeOnPDOrganismCodes < ActiveRecord::Migration
  def change
    rename_column :pd_organism_codes, :read_code, :code
  end
end
