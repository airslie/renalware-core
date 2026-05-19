# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_ecg_event_type, class: "Renalware::Events::Type", parent: :event_type do
    name { "ECG" }
    event_class_name { "Renalware::Heroic::Events::Ecg" }
  end
end
