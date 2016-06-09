FactoryGirl.define do
  factory :pathology_request_algorithm_patient_rule,
    class: "Renalware::Pathology::RequestAlgorithm::PatientRule" do
      association :lab, factory: :pathology_lab
      patient
      test_description "Test for HepB"
      sample_number_bottles 1
      sample_type nil
      frequency_type Renalware::Pathology::RequestAlgorithm::Frequency.all.sample
      last_observed_at nil
      start_date nil
      end_date nil
  end
end
