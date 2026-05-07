# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Research::Participation do
    describe "#document" do
      subject(:document) { described_class.new.document }

      it { is_expected.to respond_to(:study_number) }
      it { is_expected.to respond_to(:entry_criteria) }
      it { is_expected.to respond_to(:demographics) }
      it { is_expected.to respond_to(:consent) }
      it { is_expected.to respond_to(:withdrawal) }
      it { is_expected.to respond_to(:mri_antaros_0) }
      it { is_expected.to respond_to(:mri_antaros_2) }
      it { is_expected.to respond_to(:mri_antaros_5) }
      it { is_expected.to respond_to(:mri_antaros_other) }
      it { is_expected.to respond_to(:blood_visit_0_date) }
      it { is_expected.to respond_to(:blood_visit_1_date) }
      it { is_expected.to respond_to(:blood_visit_2_date) }
      it { is_expected.to respond_to(:blood_visit_3_date) }
      it { is_expected.to respond_to(:blood_visit_4_date) }
      it { is_expected.to respond_to(:blood_visit_5_date) }

      describe "#withdrawal" do
        subject { document.withdrawal }

        it { is_expected.to respond_to(:status) }
        it { is_expected.to respond_to(:partial_withdrawal_date) }
        it { is_expected.to respond_to(:complete_withdrawal_date) }
      end

      describe "#entry_criteria" do
        subject { document.entry_criteria }

        it { is_expected.to respond_to(:gfr_decline) }
        it { is_expected.to respond_to(:proteinuria) }
        it { is_expected.to respond_to(:low_gfr) }
      end

      describe "#demographics" do
        subject { document.demographics }

        it { is_expected.to respond_to(:education) }
        it { is_expected.to respond_to(:work) }
      end

      describe "#consent" do
        subject { document.consent }

        it { is_expected.to respond_to(:type) }
        it { is_expected.to respond_to(:date) }
      end

      describe "#clinical_history" do
        subject(:clinical_history) { document.clinical_history }

        it { is_expected.to respond_to(:diabetes_type) }
        it { is_expected.to respond_to(:other_medical_problems) }
        it { is_expected.to respond_to(:renal_replacement_therapy_ever) }

        describe "#diagnosis_dates" do
          subject { clinical_history.diagnosis_dates }

          it { is_expected.to respond_to(:diabetes) }
          it { is_expected.to respond_to(:retinopathy) }
          it { is_expected.to respond_to(:neuropathy) }
          it { is_expected.to respond_to(:coronary_artery_disease) }
          it { is_expected.to respond_to(:peripheral_artery_disease) }
          it { is_expected.to respond_to(:cerebrovascular_disease) }
          it { is_expected.to respond_to(:hypertension) }
          it { is_expected.to respond_to(:heart_failure) }
          it { is_expected.to respond_to(:arrhythmia) }
        end
      end

      describe "#mri_antaros_0" do
        subject(:mri_antaros_0) { document.mri_antaros_0 }

        %i(
          booked_for patient_informed transport_booked completed
        ).each do |att|
          it { is_expected.to respond_to(att) }
        end
      end

      describe "#biopsy_histology" do
        subject(:sub_document) { document.biopsy_histology }

        it { is_expected.to respond_to(:biopsy_date) }
        it { is_expected.to respond_to(:glomerular_score) }
        it { is_expected.to respond_to(:ifta_score) }
        it { is_expected.to respond_to(:interstitial_inflammation_score) }
        it { is_expected.to respond_to(:vascular_lesion_score) }
        it { is_expected.to respond_to(:large_vessel_present) }
        it { is_expected.to respond_to(:arteriosclerosis_score) }
        it { is_expected.to respond_to(:non_dm_pathology) }
        it { is_expected.to respond_to(:non_dm_pathology_description) }

        it do
          expect(sub_document).to validate_numericality_of(:ifta_score)
              .is_greater_than_or_equal_to(0)
              .is_less_than_or_equal_to(3)
        end

        it do
          expect(sub_document).to validate_numericality_of(:interstitial_inflammation_score)
            .is_greater_than_or_equal_to(0)
            .is_less_than_or_equal_to(2)
        end

        it do
          expect(sub_document).to validate_numericality_of(:vascular_lesion_score)
            .is_greater_than_or_equal_to(0)
            .is_less_than_or_equal_to(2)
        end

        it do
          expect(sub_document).to validate_numericality_of(:arteriosclerosis_score)
            .is_greater_than_or_equal_to(0)
            .is_less_than_or_equal_to(2)
        end
      end
    end
  end
end
