# frozen_string_literal: true

FactoryBot.define do
  factory :messaging_patient,
          class: "Renalware::Messaging::Patient",
          parent: :patient
end
