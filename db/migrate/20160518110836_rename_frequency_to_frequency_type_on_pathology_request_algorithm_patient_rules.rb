class RenameFrequencyToFrequencyTypeOnPathologyRequestAlgorithmPatientRules < ActiveRecord::Migration[4.2]
  def change
    rename_column :pathology_request_algorithm_patient_rules, :frequency, :frequency_type
  end
end
