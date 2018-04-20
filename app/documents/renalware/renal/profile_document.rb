# frozen_string_literal: true

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
    end
  end
end
