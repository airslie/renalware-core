class RemoveLastObservedAtFromPathologyRequestsPatientRules < ActiveRecord::Migration[4.2]
  def change
    remove_column :pathology_requests_patient_rules, :last_observed_at
  end
end
