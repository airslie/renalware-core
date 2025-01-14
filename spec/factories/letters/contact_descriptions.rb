FactoryBot.define do
  sequence(:system_code) { "sibling-#{it}" }
  sequence(:name) { "Sibling #{it}" }
  sequence(:position) { it }

  factory :letter_contact_description, class: "Renalware::Letters::ContactDescription" do
    system_code
    name
    position

    trait :unspecified do
      name { "Other" }
      system_code { "other" }
    end
  end
end
