# frozen_string_literal: true

require_dependency "renalware/patients"
require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class ClinicVisit < ApplicationRecord
      include Document::Base
      self.table_name = :clinic_visits
      has_paper_trail class_name: "Renalware::Clinics::Version", on: [:create, :update, :destroy]
      include Accountable
      include PatientScope
      extend Enumerize

      belongs_to :patient, touch: true
      belongs_to :clinic, -> { with_deleted }, counter_cache: true
      has_many :clinic_letters # TODO: remove as possibly redundant

      validates :date, presence: true
      validates :clinic, presence: true

      validates :date, timeliness: { type: :date }
      validates :time, timeliness: { type: :time, allow_blank: true }
      validates :pulse, "renalware/patients/pulse" => true
      validates :height, "renalware/patients/height" => true
      validates :temperature, "renalware/patients/temperature" => true

      enumerize :urine_blood, in: %i(neg trace very_low low medium high)
      enumerize :urine_protein, in: %i(neg trace very_low low medium high)

      scope :ordered, -> { order(date: :desc, created_at: :desc) }
      scope :most_recent_for_patient, ->(patient) { for_patient(patient).ordered.limit(1) }
      scope :most_recent, -> { ordered.limit(1) }
      scope :where_weight_was_measured, -> { where("weight > 0") }

      before_save :calculate_body_surface_area
      before_save :calculate_total_body_water
      before_save :calculate_bmi

      delegate :code, to: :clinic, prefix: true, allow_nil: true
      delegate :visit_number, to: :originating_appointment, allow_nil: true

      # The basic clinic visit document is empty and stored as {}.
      # An STI sub class might choose add custom data to this document by extending this
      # Document class.
      class Document < ::Document::Embedded
      end
      has_document

      def bp
        return unless systolic_bp.present? && diastolic_bp.present?

        "#{systolic_bp}/#{diastolic_bp}"
      end

      def standing_bp
        return unless standing_systolic_bp.present? && standing_diastolic_bp.present?

        "#{standing_systolic_bp}/#{standing_diastolic_bp}"
      end

      def bp=(val)
        self.systolic_bp, self.diastolic_bp = val.split("/")
      end

      def standing_bp=(val)
        self.standing_systolic_bp, self.standing_diastolic_bp = val.split("/")
      end

      def datetime
        return if date.blank?
        return date.to_datetime if time.blank?

        datetime_from_date_and_time
      end

      def to_form_partial_path
        "/renalware/clinics/clinic_visits/visit_specific_form_fields"
      end

      private

      # The originating appointment from which the VC was generated - created e.g. by HL7 A05
      def originating_appointment
        Appointment.find_by(becomes_visit_id: id)
      end
      
      def datetime_from_date_and_time
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0, time.zone)
      end

      def calculate_body_surface_area
        self.body_surface_area = BodySurfaceArea.calculate(
          height: height,
          weight: weight
        )
      end

      def calculate_total_body_water
        self.total_body_water = TotalBodyWater.calculate(
          height: height,
          weight: weight,
          age: patient.age,
          sex: patient.sex
        )
      end

      def calculate_bmi
        self.bmi = BMI.new(weight: weight, height: height).to_f
      end
    end
  end
end
