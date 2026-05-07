# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_investigatorship, class: "Renalware::Heroic::Research::Investigatorship" do
    association :by, factory: :user
    association :user, factory: :user
    association :study, factory: :research_study
    started_on { "01-01-2018" }
  end
end
