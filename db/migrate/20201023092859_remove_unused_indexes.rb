class RemoveUnusedIndexes < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      # Covered by index_admission_requests_on_patient_id_and_deleted_at
      remove_index(:admission_requests, :patient_id)

      # Covered by index_drug_homecare_forms_on_drug_type_id_and_supplier_id
      remove_index(:drug_homecare_forms, :drug_type_id)

      # Covered by survey_responses_compound_index (answered_on, patient_id, question_id)
      remove_index(:survey_responses, :answered_on)

      # Covered by idx_dashboard_component_position (dashboard_id, position)
      remove_index(:system_dashboard_components, :dashboard_id)

      # Covered by index_letter_mailshot_items_on_mailshot_id_and_letter_id
      remove_index(:letter_mailshot_items, :mailshot_id)
    end
  end
end
