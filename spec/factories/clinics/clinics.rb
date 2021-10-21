# frozen_string_literal: true

FactoryBot.define do
  factory :clinic, class: "Renalware::Clinics::Clinic" do
    sequence :code do |n|
      "C#{n}"
    end
    name { "Access" }
    association :consultant, factory: :user
  end
end
