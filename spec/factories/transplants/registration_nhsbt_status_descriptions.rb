FactoryBot.define do
  factory :transplant_registration_nhsbt_status_description,
          class: "Renalware::Transplants::RegistrationNHSBTStatusDescription" do
    initialize_with do
      Renalware::Transplants::RegistrationNHSBTStatusDescription.find_or_create_by(code:)
    end

    code { "A" }
    name { "Active" }

    trait :suspended do
      code { "S" }
      name { "Suspended" }
    end

    trait :removed do
      code { "R" }
      name { "Removed" }
    end

    trait :transplanted do
      code { "T" }
      name { "Transplanted" }
    end

    trait :work_up do
      code { "W" }
      name { "Work-up" }
    end
  end
end
