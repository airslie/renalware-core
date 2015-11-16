require "document/embedded"

module Renalware
  module Transplants
    class DonorOperationDocument < Document::Embedded
      attribute :kidney_side, enums: %i(left right both)
      attribute :operating_surgeon, enums: %i(consultant fellow_senior_registrar other)
      attribute :anaesthetist, enums: %i(consultant fellow_senior_registrar other)
      attribute :nephrectomy_type, enums: %i(
        open_transperitoneal open_loin_with_resection open_loin_without_resection
        open_extraperitoneal laparoscropic_intra laparoscropic_extra other)
      attribute :nephrectomy_type_other, String
      attribute :donor_splenectomy_peri_or_post_operatively, enums: %i(yes no unknown)

      class Diagnosis < Document::Embedded
        attribute :wound_infection, DatedConfirmation
        attribute :deep_vein_thrombosis, DatedConfirmation
        attribute :donor_pneumothorax_peri_or_post_operative, DatedConfirmation
        attribute :pneumonia, DatedConfirmation
        attribute :pulmonary_thrombo_embolism, DatedConfirmation
        attribute :prescribed_medication_indicator, enums: %i(yes no unknown)
        attribute :other_peri_or_post_operative_complications, enums: %i(yes no unknown)
      end

      class Outcome < Document::Embedded
        attribute :subsequent_operation_indicator, enums: %i(yes no unknown)
        attribute :donor_returned_to_previous_general_activity_level, enums: %i(yes no unknown)
        attribute :nb_months_to_return_to_previous_general_activity_level, Integer

        validates :nb_months_to_return_to_previous_general_activity_level,
          numericality: { allow_blank: true, only_integer: true }
      end
      attribute :outcome, Outcome
    end
  end
end