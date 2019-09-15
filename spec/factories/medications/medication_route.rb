# frozen_string_literal: true

FactoryBot.define do
  factory :medication_route, class: "Renalware::Medications::MedicationRoute" do
    initialize_with do
      Renalware::Medications::MedicationRoute.find_or_create_by!(code: code, name: name)
    end
    code { "PO" }
    name { "Per Oral" }

    trait :other do
      code { "Other" }
      name { "Other" }
    end
  end
end
