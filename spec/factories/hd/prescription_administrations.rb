# frozen_string_literal: true

FactoryBot.define do
  factory :hd_prescription_administration, class: "Renalware::HD::PrescriptionAdministration" do
    accountable
    patient
    prescription
    association :administered_by, factory: :user
    administrator_authorised { true }
    association :witnessed_by, factory: :user
    witness_authorised { true }
    administered { true }
    notes { "some notes" }
    deleted_at { nil }
    recorded_on { Time.zone.today }
  end
end
