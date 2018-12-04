class UpdatePatientSummariesToVersion5 < ActiveRecord::Migration[5.0]
  def change
    within_renalware_schema do
      update_view :patient_summaries, version: 5, revert_to_version: 4
    end
  end
end
