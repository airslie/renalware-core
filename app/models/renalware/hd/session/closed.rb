require "document/base"

# This Closed (state) Session adds validation standard HD::Session to enforce the presence of
# most fields.
module Renalware
  module HD
    class Session::Closed < Session
      include Document::Base

      validates :start_time, presence: true
      validates :signed_off_by, presence: true
      validates :end_time, presence: true
      validates :signed_off_at, presence: true

      belongs_to :profile
      belongs_to :dry_weight

      def self.policy_class
        ClosedSessionPolicy
      end

      def immutable?
        return true unless persisted?
        temporary_editing_window_has_elapsed?
      end

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

      private

      def temporary_editing_window_has_elapsed?
        delay = Renalware.config.delay_after_which_a_finished_session_becomes_immutable
        (Time.zone.now - delay) > signed_off_at
      end
    end
  end
end
