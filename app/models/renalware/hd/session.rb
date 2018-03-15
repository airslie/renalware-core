# frozen_string_literal: true

require_dependency "renalware/hd"
require "duration_calculator"

module Renalware
  module HD
    class Session < ApplicationRecord
      include PatientScope
      include Accountable
      include ExplicitStateModel

      # Prevent instances of this of this base class from being saved
      validates :type, presence: true

      has_states :open, :closed, :dna

      belongs_to :patient, touch: true
      belongs_to :profile
      belongs_to :dry_weight, class_name: "Renalware::Clinical::DryWeight"
      belongs_to :modality_description, class_name: "Modalities::Description"
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :dialysate
      belongs_to :signed_on_by, class_name: "User", foreign_key: "signed_on_by_id"
      belongs_to :signed_off_by, class_name: "User", foreign_key: "signed_off_by_id"
      has_many :prescription_administrations,
               class_name: "PrescriptionAdministration",
               foreign_key: "hd_session_id",
               dependent: :destroy
      accepts_nested_attributes_for :prescription_administrations

      has_paper_trail class_name: "Renalware::HD::Version"

      before_create :assign_modality
      before_save :compute_duration

      scope :ordered, -> { order(performed_on: :desc) }

      validates :patient, presence: true
      validates :hospital_unit, presence: true
      validates :signed_on_by, presence: true
      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date }
      validates :start_time, timeliness: { type: :time, allow_blank: true }
      validates :end_time, timeliness: { type: :time, allow_blank: true, after: :start_time }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      def start_datetime
        datetime_at(start_time)
      end

      def stop_datetime
        datetime_at(end_time)
      end

      private

      def datetime_at(time)
        Time.zone.parse("#{performed_on.strftime('%F')} #{time.strftime('%T')}")
      end

      def assign_modality
        self.modality_description = patient.modality_description
      end

      def compute_duration
        return unless start_time_changed? || end_time_changed?

        self.duration = DurationCalculator.in_minutes(start_time, end_time)
      end
    end
  end
end
