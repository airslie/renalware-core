class CreatePatientSummaries < ActiveRecord::Migration[5.0]
  def change
    create_view :patient_summaries
  end
end
