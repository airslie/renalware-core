require "document/embedded"
require "document/enum"

module Renalware
  module HD
    class SessionDocument < Document::Embedded
      class Info < Document::Embedded
        attribute :hd_type, Document::Enum, enums: %i(hd hdf_pre hdf_post)
        attribute :access_type
        attribute :access_side
        attribute :access_site
        attribute :is_access_first_use, Document::Enum, enums: %i(yes no)
        attribute :fistula_plus_line, Document::Enum, enums: %i(yes no)
        attribute :single_needle, Document::Enum, enums: %i(yes no)
        attribute :lines_reversed, Document::Enum, enums: %i(yes no)
        attribute :machine_no
        attribute :dialysis_fluid_used, Document::Enum
      end
      attribute :info, Info

      class Observations < Document::Embedded
        attribute :weight, Float
        attribute :pulse, Integer
        attribute :blood_pressure, BloodPressure
        attribute :temperature, Float
        attribute :bm_stix, Float
      end
      attribute :observations_before, Observations
      attribute :observations_after, Observations

      class Dialysis < Document::Embedded
        attribute :arterial_pressure, Integer
        attribute :venous_pressure, Integer
        attribute :fluid_remove, Float
        attribute :blood_flow, Integer
        attribute :flow_rate, Integer
        attribute :machine_urr, Integer
        attribute :machine_ktv, Float
        attribute :litres_processed, Float

        def self.flow_rates; (100..800).step(100); end

        validates :machine_urr, inclusion: { in: 0..100, allow_blank: true }
        validates :machine_ktv, inclusion: { in: (0.2..3.5), allow_blank: true }
      end
      attribute :Dialysis

      class HDF < Document::Embedded
        attribute :subs_fluid_pct, Integer
        attribute :subs_goal, Float
        attribute :subs_rate, Float
        attribute :subs_volume, Float
      end
      attribute :hdf, HDF

      class Complications < Document::Embedded
        attribute :access_site_status, Document::Enum
        attribute :was_dressing_changed, Document::Enum, enums: %i(yes no)
        attribute :had_mrsa_swab, Document::Enum, enums: %i(yes no)
        attribute :had_mssa_swab, Document::Enum, enums: %i(yes no)
        attribute :had_intradialytic_hypotension, Document::Enum, enums: %i(yes no)
        attribute :had_saline_administration, Document::Enum, enums: %i(yes no)
        attribute :had_cramps, Document::Enum, enums: %i(yes no)
        attribute :had_headache, Document::Enum, enums: %i(yes no)
        attribute :had_chest_pain, Document::Enum, enums: %i(yes no)
        attribute :had_alteplase_urokinase, Document::Enum, enums: %i(yes no)
      end
      attribute :complications, Complications
    end
  end
end
