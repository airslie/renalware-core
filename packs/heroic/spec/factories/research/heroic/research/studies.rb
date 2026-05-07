# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_research_study, class: "Renalware::Heroic::Research::Study" do
    code { "HEROIC" }
    description { "Test HEROIC study" }
    namespace { "Renalware::Heroic::Research" }
    leader { Faker::Name.name }
    started_on { 1.year.ago }
    terminated_on { nil }
    deleted_at { nil }
    accountable
  end
end
