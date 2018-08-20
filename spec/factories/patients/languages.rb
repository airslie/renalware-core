# frozen_string_literal: true

FactoryBot.define do
  factory :language, class: "Renalware::Patients::Language" do
    name { "English" }
    code { "en" }

    trait :english do
      name { "English" }
      code { "en" }
    end

    trait :afrikaans do
      name { "Afrikaans" }
      code { "af" }
    end

    trait :unknown do
      name { "Unknown" }
      code { "un" }
    end
  end
end
