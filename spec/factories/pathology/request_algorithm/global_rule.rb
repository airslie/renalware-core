FactoryGirl.define do
  factory :pathology_requests_global_rule,
    class: "Renalware::Pathology::Requests::GlobalRule" do
      association :global_rule_set, factory: :pathology_requests_global_rule_set
      param_type "ObservationResult"
      param_comparison_operator "<"
      param_comparison_value "100"
  end
end
