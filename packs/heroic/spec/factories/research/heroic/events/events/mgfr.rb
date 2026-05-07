# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_mgfr_event, class: "Renalware::Heroic::Events::Mgfr", parent: :event do
    event_type factory: :heroic_mgfr_event_type

    document {
      {
        visit_number: 0,
        uncorrected_bsa: 1.1
      }
    }
  end
end
