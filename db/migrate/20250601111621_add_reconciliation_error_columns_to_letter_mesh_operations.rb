class AddReconciliationErrorColumnsToLetterMeshOperations < ActiveRecord::Migration[7.2]
  def change
    safety_assured do
      within_renalware_schema do
        add_column(
          :letter_mesh_operations,
          :reconciliation_error,
          :boolean,
          null: false,
          default: false
        )
        add_column(
          :letter_mesh_operations,
          :reconciliation_error_description,
          :text
        )
        add_index(
          :letter_mesh_operations,
          :reconciliation_error
        )
      end
    end
  end
end
