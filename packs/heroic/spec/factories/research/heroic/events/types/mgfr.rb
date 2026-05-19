# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_mgfr_event_type, class: "Renalware::Events::Type", parent: :event_type do
    name { "mGFR" }
    event_class_name { "Renalware::Heroic::Events::Mgfr" }
  end
end
