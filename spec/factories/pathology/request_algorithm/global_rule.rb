FactoryGirl.define do
  factory :pathology_request_algorithm_global_rule,
    class: "Renalware::Pathology::RequestAlgorithm::GlobalRule" do
      global_rule_set_id 1
      param_type "ObservationResult"
      param_id "1"
      param_comparison_operator "<"
      param_comparison_value "100"
  end
end
