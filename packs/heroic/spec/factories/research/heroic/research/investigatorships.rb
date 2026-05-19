# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_investigatorship, class: "Renalware::Heroic::Research::Investigatorship" do
    by factory: %i(user)
    user factory: %i(user)
    study factory: %i(research_study)
    started_on { "01-01-2018" }
  end
end
