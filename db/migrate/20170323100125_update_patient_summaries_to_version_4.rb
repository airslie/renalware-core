class UpdatePatientSummariesToVersion4 < ActiveRecord::Migration[5.0]
  def change
    update_view :patient_summaries, version: 4, revert_to_version: 3
  end
end
