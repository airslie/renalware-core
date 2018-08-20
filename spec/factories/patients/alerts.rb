# frozen_string_literal: true

FactoryBot.define do
  factory :patient_alert, class: "Renalware::Patients::Alert" do
    accountable
    notes { Faker::Lorem.sentence }
    urgent { true }
  end
end
