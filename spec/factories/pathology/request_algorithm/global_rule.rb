FactoryGirl.define do
  factory :pathology_request_algorithm_global_rule, class: "Renalware::Pathology::RequestAlgorithm::GlobalRule" do
    observation_description_id 1
    regime "Nephrology"
    param_type "ObservationResult"
    param_id "1"
    param_comparison_operator "<"
    param_comparison_value "100"
    frequency %w(Once Always Weekly Monthly).sample
  end
end
