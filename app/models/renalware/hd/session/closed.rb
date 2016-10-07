# This Closed (state) Session adds validation standard HD::Session to enforce the presence of
# most fields.
module Renalware
  module HD
    class Session::Closed < ActiveType::Record[Session]

      validates :signed_off_by, presence: true
      validates :end_time, presence: true

      class SessionDocument < ::Renalware::HD::SessionDocument
        class Info < Renalware::HD::SessionDocument::Info
          validates_presence_of attribute_set.map(&:name)
        end
        attribute :info, Info

        class Observations < Renalware::HD::SessionDocument::Observations
          validates_presence_of :pulse, :blood_pressure, :weight_measured, :temperature_measured
          validates_presence_of :weight, if: "weight_measured.try!(:yes?)"
          validates_presence_of :temperature, if: "temperature_measured.try!(:yes?)"
          validates :blood_pressure, "renalware/patients/blood_pressure_presence" => true
        end
        attribute :observations_before, Observations
        attribute :observations_after, Observations

        class Dialysis < Renalware::HD::SessionDocument::Dialysis
          validates_presence_of attribute_set.map(&:name)
        end
        attribute :dialysis, Dialysis

        validates :hdf, "renalware/patients/hdf_presence" => true, if: :hd_type_is_hdf?

        def hd_type_is_hdf?
          ["hdf_pre", "hdf_post"].include?(info.hd_type.to_s)
        end
      end

      has_document class_name: "::Renalware::HD::Session::Closed::SessionDocument"
    end
  end
end
