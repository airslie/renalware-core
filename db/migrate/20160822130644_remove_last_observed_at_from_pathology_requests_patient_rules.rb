class RemoveLastObservedAtFromPathologyRequestsPatientRules < ActiveRecord::Migration
  def change
    remove_column :pathology_requests_patient_rules, :last_observed_at
  end
end
