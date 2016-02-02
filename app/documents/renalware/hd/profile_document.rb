require "document/embedded"
require "document/enum"

module Renalware
  module HD
    class ProfileDocument < Document::Embedded
      class Procedure < Document::Embedded
        attribute :hd_type, Document::Enum, enums: %i(hd hdf_pre hdf_post)
        attribute :cannulation_type
        attribute :needle_size
        attribute :single_needle, Document::Enum, enums: %i(yes no)
        attribute :dialysate, Document::Enum, enums: %i(a7 a10 a17 a27)
        attribute :flow_rate, Integer
        attribute :blood_flow, Integer
      end
      attribute :procedure, Procedure

      class Dialysis < Document::Embedded
        attribute :potassium, Integer
        attribute :calcium, Float
        attribute :temperature, Float
        attribute :bicarbonate, Integer
        attribute :has_sodium_profiling, Document::Enum, enums: %i(yes no)
        attribute :sodium_first_half, Integer
        attribute :sodium_second_half, Integer
        attribute :anticoagulant_type, Document::Enum, enums: %i(heparin enoxyparin warfarin none)
      end
      attribute :dialisys, Dialysis

      class Anticoagulant < Document::Embedded
        attribute :type, Document::Enum, enums: %i(heparin enoxyparin warfarin none)
        attribute :loading_dose
        attribute :hourly_dose
        attribute :stop_time
      end
      attribute :anticoagulant, Anticoagulant

      class Drugs < Document::Embedded
        attribute :on_esa, Document::Enum, enums: %i(yes no unknown)
        attribute :on_iron, Document::Enum, enums: %i(yes no unknown)
        attribute :on_warfarin, Document::Enum, enums: %i(yes no unknown)
      end
      attribute :patient, Drugs

      class Transport < Document::Embedded
        attribute :has_transport, Document::Enum, enums: %i(yes no unknown)
        attribute :type, Document::Enum
        attribute :decided_on, Date
      end
      attribute :transport, Transport

      class CareLevel < Document::Embedded
        attribute :required, Document::Enum, enums: %i(yes no unknown)
        attribute :assessed_on, Date
      end
      attribute :care_level, CareLevel
    end
  end
end