# frozen_string_literal: true

FactoryBot.define do
  factory :letter_contact, class: "Renalware::Letters::Contact" do
    description factory: %i(letter_contact_description)
  end
end
