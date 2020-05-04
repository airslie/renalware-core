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
        delegate :urine_urea,
                 :urine_creatinine,
                 :urine_24_vol,
                 :dialysate_urea,
                 :dialysate_creatinine,
                 :dial_24_vol_out,
                 :serum_urea,
                 :serum_creatinine,
                 :urine_24_missing,
                 to: :adequacy,
                 allow_nil: true

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
          return if urine_24_missing
          return if [urine_urea, serum_urea, urine_24_vol].map(&:to_i).any?(&:zero?)

          (urine_urea * urine_24_vol / 1000) / serum_urea * 7
        end

        def renal_creatinine_clearance
          return if urine_24_missing
          return if [urine_creatinine, serum_creatinine, urine_24_vol].map(&:to_i).any?(&:zero?)

          (urine_creatinine * urine_24_vol) / serum_creatinine * 7
        end

        def residual_renal_function
          return unless body_surface_area.to_i > 0
          return unless renal_creatinine_clearance && renal_urine_clearance

          (
            (renal_creatinine_clearance + renal_urine_clearance) / (2 * body_surface_area) * 1.72
          ).to_i
        end

        def pertitoneal_creatinine_clearance
          return unless dial_24_vol_out.to_i > 0
          return unless serum_creatinine.to_i > 0
          return unless dialysate_creatinine.to_i > 0
          return unless body_surface_area.to_i > 0

          (
            (dialysate_creatinine * dial_24_vol_out / 1000) /
            serum_creatinine * 7 * 1.72 / body_surface_area
          ).to_i
        end

        # TODO
        # def total_creatinine_clearance
        #   Residual Renal Function (RRF) + Peritoneal Creatinine Clearance (PeritonealCrCl)
        # end

        # # TODO
        # def dietry_protein_intake
        #   (19+0.272*((Dial24_Urea*Dial24_VolOut/1000) +
        #     (Urine24_Urea*Urine24_Vol/1000)))/Weight,2))
        # end
      end
    end
  end
end
