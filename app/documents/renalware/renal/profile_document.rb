require "document/embedded"
require "document/enum"

module Renalware
  module Renal
    class ProfileDocument < Document::Embedded
      class Comorbidities < Document::Embedded
        attribute :diabetes, YearDatedConfirmation
        attribute :ischaemic_heart_dis, YearDatedConfirmation
        attribute :cabg_or_angioplasty, YearDatedConfirmation
        attribute :heart_failure, YearDatedConfirmation
        attribute :atrial_fibrill, YearDatedConfirmation
        attribute :malignancy, YearDatedConfirmation
        attribute :cerebrovascular_dis, YearDatedConfirmation
        attribute :chronic_obstr_pulm_dis, YearDatedConfirmation
        attribute :liver_disease, YearDatedConfirmation
        attribute :periph_vascular_dis, YearDatedConfirmation
        attribute :amputation_for_pvd, YearDatedConfirmation
        attribute :claudication, YearDatedConfirmation
        attribute :ischaemic_neuropathic_ulcers, YearDatedConfirmation
        attribute :non_coronary_intervention, YearDatedConfirmation
        attribute :dementia, YearDatedConfirmation
        attribute :smoking, SmokingStatus
      end
      attribute :comorbidities, Comorbidities

      class LowClearance < Document::Embedded
        attribute :first_seen_on, Date
        attribute :dialysis_plan, Document::Enum
        attribute :dialysis_planned_on, Date
        attribute :predicted_esrf_date, Date
        attribute :referral_creatinine, Integer
        attribute :referred_by, String
        attribute :education_status, Document::Enum
        attribute :referral_egfr, Decimal
        attribute :education_type, Document::Enum
        attribute :attended_on, Date
        attribute :dvd1_provided, Document::Enum, enums: %i(yes no)
        attribute :dvd2_provided, Document::Enum, enums: %i(yes no)
        attribute :transplant_referral, Document::Enum, enums: %i(yes no)
        attribute :transplant_referred_on, Date
        attribute :home_hd_possible, Document::Enum, enums: %i(yes no)
        attribute :self_care_possible, Document::Enum, enums: %i(yes no)
        attribute :access_notes, String
      end
      attribute :low_clearance, LowClearance
    end
  end
end
