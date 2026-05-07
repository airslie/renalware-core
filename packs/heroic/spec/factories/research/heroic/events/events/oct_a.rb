# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_oct_a_event, class: "Renalware::Heroic::Events::OctA", parent: :event do
    event_type factory: :heroic_oct_a_event_type
    document {
      {
        visit_number: 0,
        screen_type: :octa,
        diabetic_retinopathy: "yes",
        skeletonized_vessel_density_continuous: 1.0,
        fractal_dimension_continuous: 2.0,
        vessel_diameter_index_continuous: 3.0,
        average_vessel_calibre_continuous: 4.0,
        foveal_avascular_zone_continuous: 5.0,
        perifoveal_interpapillary_area_continuous: 5.0,
        number_of_microaneurysms: 6
      }
    }
  end
end
