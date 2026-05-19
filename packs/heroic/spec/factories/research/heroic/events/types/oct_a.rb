# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_oct_a_event_type, class: "Renalware::Events::Type", parent: :event_type do
    name { "Retinal screen" }
    event_class_name { "Renalware::Heroic::Events::OctA" }
  end
end
