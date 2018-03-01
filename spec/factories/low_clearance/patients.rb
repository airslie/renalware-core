# frozen_string_literal: true

FactoryBot.define do
  factory :low_clearance_patient, class: "Renalware::LowClearance::Patient", parent: :patient
end
