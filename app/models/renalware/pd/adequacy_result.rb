# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class AdequacyResult < ApplicationRecord
      include PatientScope
      include Accountable
      include PatientsRansackHelper
      acts_as_paranoid

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      scope :ordered, -> { order(performed_on: :desc, created_at: :desc) }
      validates :performed_on, presence: true
      validates :dial_24_vol_in,
                numericality: { greater_than_or_equal_to: 1005, less_than_or_equal_to: 35000 },
                allow_nil: true
      validates :dial_24_vol_out,
                numericality: { greater_than_or_equal_to: 500, less_than_or_equal_to: 45000 },
                allow_nil: true
      validates :urine_24_vol,
                numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6000 },
                allow_nil: true

      before_save :derive_calculated_attributes

      def derive_calculated_attributes
        visit = Renalware::Clinics::ClinicVisit.where("body_surface_area > 0 and weight > 0").last
        return if visit.blank?

        derived_attrs = AdequacyCalculatedAttributes.new(adequacy: self, clinic_visit: visit).to_h
        assign_attributes(derived_attrs)
      end
    end
  end
end
