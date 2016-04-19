FactoryGirl.define do
  factory :pathology_request_algorithm_global_rule_set,
    class: "Renalware::Pathology::RequestAlgorithm::GlobalRuleSet" do
      observation_description_id 1
      regime "Nephrology"
      frequency %w(Once Always Weekly Monthly).sample
  end
end
