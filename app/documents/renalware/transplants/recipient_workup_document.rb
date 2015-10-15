module Renalware
  module Transplants
    class RecipientWorkupDocument < Document::Embedded

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

      class Historicals < Document::Embedded
        attribute :tb, enums: :confirmation
        attribute :dvt, enums: :confirmation
        attribute :reflux, enums: :confirmation
        attribute :neurogenic_bladder, enums: :confirmation
        attribute :recurrent_utis, enums: :confirmation
        attribute :family_diabetes, enums: :confirmation
        attribute :pregnancies_count, Integer
      end
      attribute :historicals, Historicals

      class Scores < Document::Embedded
        attribute :karnofsky, Integer
        attribute :prisma, Integer

        validates :karnofsky, inclusion: { in: 0..100, allow_blank: true }
        validates :prisma, inclusion: { in: 0..7, allow_blank: true }
      end
      attribute :scores, Scores

      class CervicalSmear < Document::Embedded
        attribute :result
        attribute :date, Date

        validates :date, timeliness: { type: :date, allow_blank: true }
      end
      attribute :cervical_smear, CervicalSmear

      class Examination < Document::Embedded
        attribute :femoral_pulse, LeftRightConfirmation
        attribute :dorsalis_pedis_pulse, LeftRightConfirmation
        attribute :posterior_tibial_pulse, LeftRightConfirmation
        attribute :carotid_bruit, LeftRightConfirmation
        attribute :femoral_bruit, LeftRightConfirmation
        attribute :heart_sounds, Integer
      end
      attribute :examination, Examination

      class TransplantConsents < Document::Embedded
        attribute :consent, enums: [:full, :partial, :refused]
        attribute :consent_date, Date
        attribute :consenting_name
        attribute :marginal_consent, enums: :confirmation
        attribute :marginal_consent_date, Date
        attribute :marginal_consenting_name

        validates :consent_date, timeliness: { type: :date, allow_blank: true }
        validates :consent_date, presence: true, if: "consent.present?"
        validates :consenting_name, presence: true, if: "consent.present?"
        validates :marginal_consenting_name, presence: true,
          if: "marginal_consent.try(:yes?)"
      end
      attribute :transplant_consents, TransplantConsents

      class Education < Document::Embedded
        attribute :waiting_list, enums: :confirmation
        attribute :transport_benefits, enums: :confirmation
        attribute :procedure, enums: :confirmation
        attribute :infection, enums: :confirmation
        attribute :rejection, enums: :confirmation
        attribute :success_rate, enums: :confirmation
        attribute :drugs_shortterm, enums: :confirmation
        attribute :drugs_longterm, enums: :confirmation
        attribute :cancer, enums: :confirmation
        attribute :followup, enums: :confirmation
        attribute :recurrence, enums: :confirmation
      end
      attribute :education, Education

      # Misc
      attribute :hla_data
    end
  end
end