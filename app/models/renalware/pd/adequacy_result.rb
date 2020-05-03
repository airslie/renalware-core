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
        visit = Renalware::Clinics::ClinicVisit.last
        assign_attributes(CalculatedAttributes.new(adequacy: self, clinic_visit: visit).to_h)
      end

      class CalculatedAttributes
        pattr_initialize [:adequacy!, :clinic_visit!]
        delegate :total_body_water, :body_surface_area, :weight, :height, to: :clinic_visit
        delegate :urine_urea, :urine_creatinine, :urine_24_vol, :serum_urea, to: :adequacy
        # :weight, :height, :total_body_water, :body_surface_area

        def to_h
          return {} unless adequacy
          return {} unless clinic_visit

          {
            total_creatinine_clearance: 1,
            pertitoneal_creatinine_clearance: 2,
            renal_creatinine_clearance: 3,
            total_ktv: 4,
            pertitoneal_ktv: 5,
            renal_ktv: 6,
            dietry_protein_intake: 7
          }
        end

        def renal_urine_clearance
          return if adequacy.urine_24_missing

          (urine_urea * urine_24_vol / 1000) / serum_urea * 7
        end
      end

      # def dietry_protein_intake
      #   (19+0.272*((Dial24_Urea*Dial24_VolOut/1000) + (Urine24_Urea*Urine24_Vol/1000)))/Weight,2))
      # end
    end
  end
end
