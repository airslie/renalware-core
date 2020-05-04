# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class AdequacyResult < ApplicationRecord
      include PatientScope
      include Accountable
      acts_as_paranoid

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      scope :ordered, -> { order(created_at: :desc) }
      validates :performed_on, presence: true

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
