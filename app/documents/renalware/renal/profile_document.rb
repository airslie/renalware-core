require "document/embedded"
require "document/enum"

module Renalware
  module Renal
    class ProfileDocument < Document::Embedded

      class Comorbidities < Document::Embedded
        attribute :angina, YearDatedConfirmation
        attribute :myocardial_infarct, YearDatedConfirmation
        attribute :coronary_artery_bypass_graft, YearDatedConfirmation
        attribute :heart_failure, YearDatedConfirmation
        attribute :chronic_obstr_pulm_dis, YearDatedConfirmation
        attribute :cvd_or_stroke, YearDatedConfirmation
        attribute :diabetes, YearDatedConfirmation
        attribute :malignancy, YearDatedConfirmation
        attribute :liver_disease, YearDatedConfirmation
        attribute :claudication, YearDatedConfirmation
        attribute :ischaemic_neuropathic_ulcers, YearDatedConfirmation
        attribute :non_coronary_angioplasty, YearDatedConfirmation
        attribute :amputation_for_pvd, YearDatedConfirmation
      end
      attribute :comorbidities, Comorbidities

    end
  end
end
