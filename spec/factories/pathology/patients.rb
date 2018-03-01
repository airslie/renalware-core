# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_patient, class: "Renalware::Pathology::Patient", parent: :patient
end
