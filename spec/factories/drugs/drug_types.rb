# frozen_string_literal: true

FactoryBot.define do
  factory :drug_type, class: "Renalware::Drugs::Type" do
    code { "immuno" }
    name { "Immunosuppressant" }

    trait :immunosuppressant do
      code { "immunosuppressant" }
      name { "Immunosuppressant" }
    end

    trait :esa do
      code { "esa" }
      name { "ESA" }
    end
  end
end
