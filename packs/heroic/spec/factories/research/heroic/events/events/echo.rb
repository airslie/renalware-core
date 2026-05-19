# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_echo_event, class: "Renalware::Heroic::Events::Echo", parent: :event do
    event_type factory: :heroic_echo_event_type
    document {
      {
        visit_number: 0,
        la_vol: 0.1,
        lvidd_2d: 1.1,
        ivsd_2d: 2.2,
        pwd_2d: 3.3,
        lv_ed_vol: 4.4,
        ra_area: 5.5,
        rv_diameter: 6.6,
        tapse: 7.7,
        estimated_lvf: 8.8,
        estimated_rvsp: 9.9,
        valve_pathology: "valve pathology"
      }
    }
  end
end
