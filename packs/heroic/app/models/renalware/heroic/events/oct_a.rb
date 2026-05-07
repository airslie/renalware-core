# frozen_string_literal: true

module Renalware
  module Heroic
    module Events
      class OctA < HeroicEvent
        class Document < Heroic::Document
          MAX_VISIT_NUMBER = 5
          attribute :visit_number, Integer
          attribute :screen_type, ::Document::Enum
          attribute :diabetic_retinopathy, ::Document::Enum, enums: %i(yes no)
          %i(
            skeletonized_vessel_density_continuous
            fractal_dimension_continuous
            vessel_diameter_index_continuous
            average_vessel_calibre_continuous
            foveal_avascular_zone_continuous
            perifoveal_interpapillary_area_continuous
            number_of_microaneurysms
          ).each do |att|
            attribute att, Float
            validates att, numericality: true, allow_nil: true
          end

          validates :visit_number,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: MAX_VISIT_NUMBER
                    },
                    allow_nil: true
        end
        has_document
      end
    end
  end
end
