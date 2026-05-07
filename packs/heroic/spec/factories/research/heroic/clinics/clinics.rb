# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_clinic, parent: :clinic do
    visit_class_name { "Renalware::Heroic::Clinics::Visit" }
    name { "HEROIC" }
  end
end
