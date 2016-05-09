FactoryGirl.define do
  factory :pathology_request_algorithm_global_rule_set,
    class: "Renalware::Pathology::RequestAlgorithm::GlobalRuleSet" do
      association :request_description, factory: :pathology_request_description
      association :clinic, factory: :clinic
      frequency Renalware::Pathology::RequestAlgorithm::GlobalRuleSet::FREQUENCIES.sample
  end
end
