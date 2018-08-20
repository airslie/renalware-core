# frozen_string_literal: true

FactoryBot.define do
  factory :aki_alert, class: "Renalware::Renal::AKIAlert" do
    accountable
    notes { "Some notes" }
    hotlist { false }
    association :action, factory: :aki_alert_action
    hospital_ward
  end
end
