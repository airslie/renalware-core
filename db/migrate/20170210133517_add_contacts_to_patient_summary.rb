class AddContactsToPatientSummary < ActiveRecord::Migration[5.0]
  def change
    update_view :patient_summaries, version: 2, revert_to_version: 1
  end
end
