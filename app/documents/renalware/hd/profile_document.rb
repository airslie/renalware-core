require "document/embedded"
require "document/enum"

module Renalware
  module HD
    class ProfileDocument < Document::Embedded
      class Dialysis < Document::Embedded
        attribute :hd_type, Document::Enum, enums: %i(hd hdf_pre hdf_post)
        attribute :cannulation_type
        attribute :needle_size
        attribute :single_needle, Document::Enum, enums: %i(yes no)
        attribute :dialysate, Document::Enum, enums: %i(a7 a10 a17 a27)
        attribute :flow_rate, Integer
        attribute :blood_flow, Integer
        attribute :dialyser
        attribute :potassium, Integer
        attribute :calcium, Float
        attribute :temperature, Float
        attribute :bicarbonate, Integer
        attribute :has_sodium_profiling, Document::Enum, enums: %i(yes no)
        attribute :sodium_first_half, Integer
        attribute :sodium_second_half, Integer

        def self.cannulation_types; CannulationType.ordered; end
        def self.flow_rates; (100..800).step(100); end
        def self.blood_flows; (50..400).step(50); end
        def self.dialysers; Dialyser.ordered; end
        def self.potassium_levels; [1, 2, 3, 4]; end
        def self.calcium_levels; [1.0, 1.35, 1.5]; end
        def self.temperature_levels; [35.0, 35.5, 36.0, 37.0]; end
        def self.bicarbonate_levels; (30..40).step(5); end
        def self.sodium_levels; [136, 137, 138, 140, 145]; end
      end
      attribute :dialysis, Dialysis

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
      attribute :drugs, Drugs

      class Transport < Document::Embedded
        attribute :has_transport, Document::Enum, enums: %i(yes no unknown)
        attribute :type, Document::Enum # See .yml file for values
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