# frozen_string_literal: true

FactoryBot.define do
  sequence :clinic_name do |n|
    "Access Clinic #{n}"
  end

  factory :clinic, class: "Renalware::Clinics::Clinic" do
    name { generate(:clinic_name) }

    association :consultant, factory: :user
  end
end
