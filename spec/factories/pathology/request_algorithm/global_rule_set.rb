FactoryGirl.define do
  factory :pathology_requests_global_rule_set,
    class: "Renalware::Pathology::Requests::GlobalRuleSet" do
      association :request_description, factory: :pathology_request_description
      association :clinic, factory: :clinic
      frequency_type Renalware::Pathology::Requests::Frequency.all_names.sample
  end
end
