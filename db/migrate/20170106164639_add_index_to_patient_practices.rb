class AddIndexToPatientPractices < ActiveRecord::Migration
  def change
    add_index :patient_practices, :code
  end
end
