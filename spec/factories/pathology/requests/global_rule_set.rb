# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_requests_global_rule_set,
          class: "Renalware::Pathology::Requests::GlobalRuleSet" do
    frequency_type { Renalware::Pathology::Requests::Frequency.all_names.sample }
  end
end
