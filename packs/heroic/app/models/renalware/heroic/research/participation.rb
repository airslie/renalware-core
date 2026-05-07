# frozen_string_literal: true


module Renalware
  module Heroic
    module Research
      #
      # This class defines the HEROIC Study participation document which is stored as jsonb in the
      # research_participations table.
      # renalware-core will use an instance of this class (via STI) when adding a particpant to
      # the HEROIC study (because for example ""::Research::Heroic" is in the #namespace column).
      #
      class Participation < Renalware::Research::Participation
        class Document < Heroic::Document
          attribute :study_number, String
          attribute :rfh_validation_code, String # RFH = Royal Free Hospital

          # def initialize(*args)
          #   self.blood_visit_date = Array.new(6)
          # end

          class Withdrawal < Heroic::Document
            attribute :status, ::Document::Enum
            attribute :partial_withdrawal_date, Date
            attribute :complete_withdrawal_date, Date
          end
          attribute :withdrawal, Withdrawal

          class Consent < Heroic::Document
            attribute :type, ::Document::Enum
            attribute :date, Date
          end
          attribute :consent, Consent

          class Demographics < Heroic::Document
            attribute :education, Integer
            attribute :work, ::Document::Enum
          end
          attribute :demographics, Demographics

          class EntryCriteria < Heroic::Document
            attribute :gfr_decline, ::Document::Enum, enums: %i(yes no)
            attribute :proteinuria, ::Document::Enum, enums: %i(yes no)
            attribute :low_gfr, ::Document::Enum, enums: %i(yes no)
          end
          attribute :entry_criteria, EntryCriteria

          class ClinicalHistory < Heroic::Document
            attribute :diabetes_type, ::Document::Enum, enums: %i(1 2)
            attribute :other_medical_problems, String
            attribute :renal_replacement_therapy_ever, ::Document::Enum, enums: %i(yes no)

            class DiagnosisDates < Heroic::Document
              attribute :diabetes, Date
              attribute :retinopathy, Date
              attribute :neuropathy, Date
              attribute :coronary_artery_disease, Date
              attribute :peripheral_artery_disease, Date
              attribute :cerebrovascular_disease, Date
              attribute :hypertension, Date
              attribute :heart_failure, Date
              attribute :arrhythmia, Date
            end
            attribute :diagnosis_dates, DiagnosisDates
          end
          attribute :clinical_history, ClinicalHistory

          class MriAntaros < Heroic::Document
            attribute :booked_for, DateTime
            attribute :patient_informed, String
            attribute :transport_booked, String
            attribute :completed, ::Document::Enum, enums: %i(yes no)
            validates :booked_for,
                      timeliness: { type: :datetime, allow_blank: true }
          end
          attribute :mri_antaros_0, MriAntaros
          attribute :mri_antaros_2, MriAntaros
          attribute :mri_antaros_5, MriAntaros
          attribute :mri_antaros_other, MriAntaros

          attribute :blood_visit_0_date, Date
          attribute :blood_visit_1_date, Date
          attribute :blood_visit_2_date, Date
          attribute :blood_visit_3_date, Date
          attribute :blood_visit_4_date, Date
          attribute :blood_visit_5_date, Date

          class BiopsyHistology < Heroic::Document
            attribute :no_biopsy, Boolean
            attribute :no_biopsy_date, Date
            attribute :no_biopsy_reason, String
            attribute :biopsy_date, Date
            attribute :glomerular_score, ::Document::Enum
            attribute :ifta_score, Integer
            attribute :interstitial_inflammation_score, Integer
            attribute :vascular_lesion_score, Integer
            attribute :large_vessel_present, ::Document::Enum, enums: %i(yes no)
            attribute :arteriosclerosis_score, Integer
            attribute :non_dm_pathology, ::Document::Enum, enums: %i(yes no)
            attribute :non_dm_pathology_description, String

            validates :ifta_score,
                      numericality: {
                        greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 3,
                        only_integer: true
                      },
                      allow_nil: true
            validates :interstitial_inflammation_score,
                      numericality: {
                        greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 2,
                        only_integer: true
                      },
                      allow_nil: true
            validates :vascular_lesion_score,
                      numericality: {
                        greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 2,
                        only_integer: true
                      },
                      allow_nil: true
            validates :arteriosclerosis_score,
                      numericality: {
                        greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 2,
                        only_integer: true
                      },
                      allow_nil: true
          end
          attribute :biopsy_histology, BiopsyHistology
        end

        has_document
      end
    end
  end
end
