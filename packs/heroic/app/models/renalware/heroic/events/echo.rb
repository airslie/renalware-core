# frozen_string_literal: true


module Renalware
  module Heroic
    module Events
      class Echo < HeroicEvent
        class Document < Heroic::Document
          MAX_VISIT_NUMBER = 2
          attribute :visit_number, Integer
          attribute :valve_pathology, String

          %i(
            la_vol
            lvidd_2d
            ivsd_2d
            pwd_2d
            lv_ed_vol
            ra_area
            rv_diameter
            tapse
            estimated_lvf
            estimated_rvsp
          ).each do |attr_name|
            attribute attr_name, Float
            validates attr_name, numericality: true, allow_nil: true
          end
          validates(
            :visit_number,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: MAX_VISIT_NUMBER
            },
            allow_nil: true
          )
        end
        has_document
      end
    end
  end
end
