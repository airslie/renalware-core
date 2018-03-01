# frozen_string_literal: true

FactoryBot.define do
  factory :medication_route, class: "Renalware::Medications::MedicationRoute" do
    code "PO"
    name "Per Oral"
  end

  trait :other do
    code "Other"
    name "Other"
  end
end
