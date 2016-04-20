FactoryGirl.define do
  factory :pathology_request_algorithm_global_rule_set,
    class: "Renalware::Pathology::RequestAlgorithm::GlobalRuleSet" do
      association :observation_description, factory: :pathology_observation_description
      regime "Nephrology"
      frequency %w(Once Always Weekly Monthly).sample
  end
end
