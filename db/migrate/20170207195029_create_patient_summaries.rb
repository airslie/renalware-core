class CreatePatientSummaries < ActiveRecord::Migration
  def change
    create_view :patient_summaries
  end
end
