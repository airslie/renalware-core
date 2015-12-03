require "document/embedded"
require 'document/enum'

module Renalware
  module Transplants
    class DonorWorkupDocument < Document::Embedded
      class Comorbidities < Document::Embedded
        attribute :angina, DatedConfirmation
        attribute :myocardial_infarct, DatedConfirmation
        attribute :coronary_artery_bypass_graft, DatedConfirmation
        attribute :heart_failure, DatedConfirmation
        attribute :smoking, DatedConfirmation
        attribute :chronic_obstr_pulm_dis, DatedConfirmation
        attribute :cvd_or_stroke, DatedConfirmation
        attribute :diabetes, DatedConfirmation
        attribute :malignancy, DatedConfirmation
        attribute :liver_disease, DatedConfirmation
        attribute :claudication, DatedConfirmation
        attribute :ischaemic_neuropathic_ulcers, DatedConfirmation
        attribute :non_coronary_angioplasty, DatedConfirmation
        attribute :amputation_for_pvd, DatedConfirmation
      end
      attribute :comorbidities, Comorbidities

      class Infections < Document::Embedded
        attribute :hiv, InfectionStatus
        attribute :hcv, InfectionStatus
        attribute :htlv_preop, InfectionStatus
        attribute :syphilis_preop, InfectionStatus
        attribute :htlv, DatedTest
        attribute :ebv, DatedTest
        attribute :syphilis, DatedTest
        attribute :toxoplasmosis, DatedTest
        attribute :cytology, DatedTest
      end
      attribute :infections, Infections

      class ImagingAndScans < Document::Embedded
        attribute :ecg_comment, DatedResult
        attribute :chest_xray, DatedResult
        attribute :renal_ultrasound, DatedResult
      end
      attribute :imaging_and_scans, ImagingAndScans

      class CreatinineClearance < Document::Embedded
        attribute :clearance_type, Document::Enum, enums: %w(cockroft_gault schwartz other)
        attribute :clearance, DatedResult
        attribute :measured_clearance, DatedResult
      end
      attribute :creatinine_clearance, CreatinineClearance

      class GlomerularFiltrationRate < Document::Embedded
        attribute :is_measured_value_corrected, Boolean
        attribute :value_corrected_for_bsa, Boolean
        attribute :measured_value, DatedResult
        attribute :isotopic_value, DatedResult
      end
      attribute :glomerular_filtration_rate, GlomerularFiltrationRate

      class UrineDipsticks < Document::Embedded
        attribute :blood, DatedResult
        attribute :protein, DatedResult
      end
      attribute :urine_dipsticks, UrineDipsticks

      class OtherInvestigations < Document::Embedded
        attribute :number_renal_arteries, Integer
        attribute :sitting_blood_pressure
        attribute :protein_creatinine_ratio, DatedResult
        attribute :egfr, DatedResult
        attribute :haemoglobinopathy, DatedResult
        attribute :oral_gtt, DatedResult
      end
      attribute :other_investigations, OtherInvestigations
    end
  end
end