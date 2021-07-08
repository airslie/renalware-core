# frozen_string_literal: true

FactoryBot.define do
  factory :event_subtype, class: "Renalware::Events::Subtype" do
    association :by, factory: :user
    association :event_type
    name { "Subtype1" }
    description { "SubtypeDesc1" }
    definition { [{ x: "y" }] }
  end
end
