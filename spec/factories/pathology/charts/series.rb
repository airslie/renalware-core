# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_chart_series, class: "Renalware::Pathology::Charts::Series" do
    association :chart, factory: :pathology_chart
    association :observation_description, factory: :pathology_observation_description
  end
end
