# frozen_string_literal: true

FactoryBot.define do
  factory :appointment, class: "Renalware::Clinics::Appointment" do
    patient
    clinic
    starts_at { Time.zone.now }
    association :consultant, factory: :consultant
  end
end
