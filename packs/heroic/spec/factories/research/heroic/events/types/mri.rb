# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_mri_event_type, class: "Renalware::Events::Type", parent: :event_type do
    name { "MRI" }
    event_class_name { "Renalware::Heroic::Events::Mri" }
  end
end
