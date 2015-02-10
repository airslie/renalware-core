class AddIndexForDeletedAtToPatientProblems < ActiveRecord::Migration
  def change
    add_index :patient_problems, :deleted_at
  end
end
