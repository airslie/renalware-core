# frozen_string_literal: true

FactoryBot.define do
  factory :letter_description, class: "Renalware::Letters::Description" do
    text "Clinic letter"
  end
end
