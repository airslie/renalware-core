class AddCatheterInsertionTechniqueIdToAccessProcedures < ActiveRecord::Migration[5.0]
  def change
    add_column :access_procedures, :pd_catheter_insertion_technique_id, :integer
    add_index :access_procedures,
              :pd_catheter_insertion_technique_id,
              name: :access_procedure_pd_catheter_tech_idx
  end
end
