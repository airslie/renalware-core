class AddIndexToPatientPractices < ActiveRecord::Migration[4.2]
  def change
    add_index :patient_practices, :code
  end
end
