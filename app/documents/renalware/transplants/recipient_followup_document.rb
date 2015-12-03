require "document/embedded"

module Renalware
  module Transplants
    class RecipientFollowupDocument < Document::Embedded
      attribute :cardiovascular_complication,
        enums: %i(myocardial_infact peripheral_vascular_disease stoke transient_ischaemic_attack)
      attribute :primary_or_reccurent_renal_disease, DatedConfirmation
      attribute :primary_or_reccurent_renal_disease_diagnosed_on, Date
      attribute :malignancy_within_first_12_months, DatedConfirmation
      attribute :malignancy_within_first_3_months, DatedConfirmation
      attribute :recipient_pregnancy, DatedConfirmation
      attribute :transplant_failed, enums: %i(yes no unknown)
      attribute :transplant_failed_on, Date
      attribute :transplant_failure_cause
      attribute :acute_rejection_biopsy_proven, DatedConfirmation

      validates :primary_or_reccurent_renal_disease_diagnosed_on,
        timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on, timeliness: { type: :date, allow_blank: true }
    end
  end
end