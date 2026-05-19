# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_echo_event_type, class: "Renalware::Events::Type", parent: :event_type do
    name { "Echo" }
    event_class_name { "Renalware::Heroic::Events::Echo" }
  end
end
