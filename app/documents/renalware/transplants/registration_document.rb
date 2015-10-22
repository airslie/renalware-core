require "document/embedded"

module Renalware
  module Transplants
    class RegistrationDocument < Document::Embedded

      TRANSPLANT_TYPES = %i(kidney kidney_pancreas pancreas kidney_liver liver)

      class Codes < Document::Embedded
        attribute :uk_transplant_centre_code
        attribute :uk_transplant_patient_recipient_number
      end
      attribute :codes, Codes

      class CRF < Document::Embedded
        attribute :highest, DatedResult
        attribute :latest, DatedResult
      end
      attribute :crf, CRF

      class Transplant < Document::Embedded
        attribute :blood_group
        attribute :hla_type, DatedResult
        attribute :nb_of_previous_grafts, Integer
        attribute :sens_status
      end
      attribute :transplant, Transplant

      class Organs < Document::Embedded
        attribute :transplant_type, enums: TRANSPLANT_TYPES
        attribute :pancreas_only_type, enums: %i(solid_organ islets)
        attribute :rejection_risk, enums: %i(low standard high individualised)
        attribute :also_listed_for_kidney_only, enums: %i(yes no unknown)
        attribute :to_be_listed_for_other_organs, enums: %i(yes no unknown)
        attribute :received_previous_kidney_or_pancreas_grafts, enums: %i(yes no unknown)
      end
      attribute :organs, Organs

      class Consent < Document::Embedded
        attribute :value, enums: %i(yes no unkwown)
        attribute :date, Date
        attribute :name

        validates :date, timeliness: { type: :date, allow_blank: true }
        validates :date, presence: true, if: "value.present?"
        validates :name, presence: true, if: "value.present?"
      end
      attribute :nhb_consent, Consent

      class Admin < Document::Embedded
        attribute :referral_date, Date
        attribute :assessment_date, Date
        attribute :wait_list_contact
        attribute :notes
      end
      attribute :admin, Admin
    end
  end
end