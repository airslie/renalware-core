FactoryBot.define do
  factory :letter_contact, class: "Renalware::Letters::Contact" do
    association :description, factory: :letter_contact_description
  end
end
