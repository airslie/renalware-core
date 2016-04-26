FactoryGirl.define do
  factory :pathology_request_algorithm_patient_rule,
    class: "Renalware::Pathology::RequestAlgorithm::PatientRule" do
      patient
      lab "Biochem"
      test_description "Test for HepB"
      sample_number_bottles 1
      sample_type nil
      frequency %w(Once Always Weekly Monthly).sample
      last_observed_at nil
      start_date nil
      end_date nil
  end
end
