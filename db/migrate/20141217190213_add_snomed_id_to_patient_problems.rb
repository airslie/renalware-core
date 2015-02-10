class AddSnomedIdToPatientProblems < ActiveRecord::Migration
  def change
    add_column :patient_problems, :snomed_id, :string
  end
end
