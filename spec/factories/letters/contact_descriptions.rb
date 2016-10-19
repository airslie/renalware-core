FactoryGirl.define do
  sequence(:system_code) { |n| "sibling-#{n}" }
  sequence(:name) { |n| "Sibling #{n}" }
  sequence(:position) { |n| n }

  factory :letter_contact_description, class: "Renalware::Letters::ContactDescription" do
    system_code
    name
    position
  end
end
