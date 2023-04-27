class AddFrequencyCommentToMedicationPrescriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :medication_prescriptions, :frequency_comment, :string
  end
end
