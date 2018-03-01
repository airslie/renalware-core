# frozen_string_literal: true

FactoryBot.define do
  factory :accesses_patient, class: "Renalware::Accesses::Patient", parent: :patient
end
