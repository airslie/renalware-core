# frozen_string_literal: true

require "document/embedded"
require "document/enum"

module Renalware
  module HD
    NullSessionDocument = Naught.build do |config|
      config.black_hole
      config.define_explicit_conversions
      config.singleton
    end

    class SessionDocument < Document::Embedded
      class Info < Document::Embedded
        attribute :hd_type, Document::Enum, enums: %i(hd hdf_pre hdf_post)
        attribute :access_confirmed, Boolean
        attribute :access_type
        attribute :access_type_abbreviation
        attribute :access_side, Document::Enum, enums: %i(left right)
        attribute :is_access_first_use, Document::Enum, enums: %i(yes no), default: :no
        attribute :fistula_plus_line, Document::Enum, enums: %i(yes no), default: :no
        attribute :single_needle, Document::Enum, enums: %i(yes no), default: :no
        attribute :lines_reversed, Document::Enum, enums: %i(yes no), default: :no
        attribute :machine_no
      end
      attribute :info, Info

      class Observations < Document::Embedded
        attribute :weight, Float
        attribute :weight_measured, Document::Enum, enums: %i(yes no), default: :yes
        attribute :pulse, Integer
        attribute :blood_pressure, BloodPressure
        attribute :temperature, Float
        attribute :temperature_measured, Document::Enum, enums: %i(yes no), default: :yes
        attribute :bm_stix, Float

        %i(
          weight
          temperature
          bm_stix
          pulse
        ).each { |att| validates(att, numericality: { allow_blank: true }) }

        validates :weight, "renalware/patients/weight" => true
        validates :temperature, "renalware/patients/temperature" => true
        validates :bm_stix, "renalware/patients/bm_stix" => true
        validates :pulse, "renalware/patients/pulse" => true
      end
      attribute :observations_before, Observations
      attribute :observations_after, Observations

      class Dialysis < Document::Embedded
        attribute :arterial_pressure, Integer
        attribute :venous_pressure, Integer
        attribute :fluid_removed, Float
        attribute :blood_flow, Integer # aka pump speed
        attribute :flow_rate, Integer
        attribute :machine_urr, Integer
        attribute :machine_ktv, Float
        attribute :litres_processed, Float

        def self.flow_rates
          (100..800).step(100)
        end

        %i(
          arterial_pressure
          venous_pressure
          fluid_removed
          flow_rate
          machine_urr
          machine_ktv
          litres_processed
        ).each { |att| validates(att, numericality: { allow_blank: true }) }

        validates :machine_urr, inclusion: { in: 0..100, allow_blank: true }
        validates :machine_ktv, inclusion: { in: (0.05..3.5), allow_blank: true }
        validates :blood_flow, numericality: {
          greater_than_or_equal_to: 50,
          less_than_or_equal_to: 800,
          allow_blank: true
        }
      end
      attribute :dialysis, Dialysis

      class HDF < Document::Embedded
        attribute :subs_fluid_pct, Integer
        attribute :subs_goal, Float
        attribute :subs_rate, Float
        attribute :subs_volume, Float

        %i(
          subs_fluid_pct
          subs_goal
          subs_rate
          subs_volume
        ).each { |att| validates(att, numericality: { allow_blank: true }) }
      end
      attribute :hdf, HDF

      class Complications < Document::Embedded
        attribute :access_site_status, Document::Enum
        attribute :line_exit_site_status, Document::Enum
        attribute :was_dressing_changed, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_mrsa_swab, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_mssa_swab, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_intradialytic_hypotension, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_saline_administration, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_cramps, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_headache, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_chest_pain, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_alteplase_urokinase, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_blood_transfusion, Document::Enum, enums: %i(yes no), default: :no

        validates :line_exit_site_status, presence: true
      end
      attribute :complications, Complications

      # rubocop:disable Metrics/AbcSize
      def error_messages
        [
          observations_before.errors.full_messages,
          observations_after.errors.full_messages,
          dialysis.errors.full_messages,
          info.errors.full_messages,
          complications.errors.full_messages,
          hdf.errors.full_messages
        ].flatten.compact
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
