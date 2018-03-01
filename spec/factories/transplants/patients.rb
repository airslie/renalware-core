# frozen_string_literal: true

FactoryBot.define do
  factory :transplant_patient, class: "Renalware::Transplants::Patient", parent: :patient
end
