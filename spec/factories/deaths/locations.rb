# frozen_string_literal: true

FactoryBot.define do
  factory :death_location, class: "Renalware::Deaths::Location" do
    initialize_with { Renalware::Deaths::Location.find_or_create_by!(name: name) }
    name { "Hospital" }

    trait :hospital do
      name { "Hospital" }
    end

    trait :hospice do
      name { "Hospice" }
    end

    trait :home do
      name { "Home" }
    end
  end
end
