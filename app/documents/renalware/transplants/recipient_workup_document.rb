require "document/embedded"

module Renalware
  module Transplants
    class RecipientWorkupDocument < Document::Embedded

      CONFIRMATION = %i(yes no)

      class Comorbidities < Document::Embedded
        attribute :angina, YearDatedConfirmation
        attribute :myocardial_infarct, YearDatedConfirmation
        attribute :coronary_artery_bypass_graft, YearDatedConfirmation
        attribute :heart_failure, YearDatedConfirmation
        attribute :smoking, YearDatedConfirmation
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

      class Historicals < Document::Embedded
        attribute :tb, enums: CONFIRMATION
        attribute :dvt, enums: CONFIRMATION
        attribute :reflux, enums: CONFIRMATION
        attribute :neurogenic_bladder, enums: CONFIRMATION
        attribute :recurrent_utis, enums: CONFIRMATION
        attribute :family_diabetes, enums: CONFIRMATION
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
        attribute :recorded_on, Date

        validates :recorded_on, timeliness: { type: :date, allow_blank: true }
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

      class Consent < Document::Embedded
        attribute :value, enums: %i(full partial refused)
        attribute :consented_on, Date
        attribute :full_name

        validates :consented_on, timeliness: { type: :date, allow_blank: true }
        validates :consented_on, presence: true, if: "value.present?"
        validates :full_name, presence: true, if: "value.present?"
      end
      attribute :consent, Consent

      class MarginalConsent < Document::Embedded
        attribute :value, enums: %i(yes no unknown)
        attribute :consented_on, Date
        attribute :full_name

        validates :consented_on, timeliness: { type: :date, allow_blank: true }
        validates :consented_on, presence: true, if: "value.present?"
        validates :full_name, presence: true, if: "value.present?"
      end
      attribute :marginal_consent, MarginalConsent

      class Education < Document::Embedded
        attribute :waiting_list, enums: CONFIRMATION
        attribute :transport_benefits, enums: CONFIRMATION
        attribute :procedure, enums: CONFIRMATION
        attribute :infection, enums: CONFIRMATION
        attribute :rejection, enums: CONFIRMATION
        attribute :success_rate, enums: CONFIRMATION
        attribute :drugs_shortterm, enums: CONFIRMATION
        attribute :drugs_longterm, enums: CONFIRMATION
        attribute :cancer, enums: CONFIRMATION
        attribute :followup, enums: CONFIRMATION
        attribute :recurrence, enums: CONFIRMATION
      end
      attribute :education, Education

      # Misc
      attribute :hla_data
    end
  end
end
