FactoryGirl.define do
  factory :pathology_request_algorithm_global_rule,
    class: "Renalware::Pathology::RequestAlgorithm::GlobalRule" do
      association :global_rule_set, factory: :pathology_request_algorithm_global_rule_set
      param_type "ObservationResult"
      param_id "1"
      param_comparison_operator "<"
      param_comparison_value "100"
  end
end
