# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    describe TreatmentTimeline::GenerateTimeline do
      include PatientsSpecHelper

      subject(:service) { described_class.new(patient) }

      let(:user) { create(:user) }
      let(:patient) { create(:patient) }
      let(:hd_mod_desc) { create(:hd_modality_description) }
      let(:hd_ukrdc_modality_code) { create(:ukrdc_modality_code, :hd) }
      let(:hdf_ukrdc_modality_code) { create(:ukrdc_modality_code, :hdf) }

      context "when the patient has no modality" do
        it "does not generate a timeline row" do
          expect(patient.modalities.count).to eq(0)

          service.call

          expect(UKRDC::Treatment.count).to eq(0)
        end
      end

      context "when the patient has one simple modality" do
        it "generates one Treatment with the relevant UKRDC modality code" do
          set_modality(patient: patient, modality_description: hd_mod_desc, by: user)
          hd_ukrdc_modality_code
          hdf_ukrdc_modality_code

          service.call

          expect(UKRDC::Treatment.count).to eq(1)
          expect(UKRDC::Treatment.first).to have_attributes(
            modality_code: hd_ukrdc_modality_code,
            clinician: user,
            patient: patient,
            started_on: patient.current_modality.started_on,
            ended_on: nil
          )
        end
      end

      context "when the patient has 2 simple modalities" do
        it "generates 2 Treatment with the relevant UKRDC modality code" do
          options = { patient: patient, modality_description: hd_mod_desc, by: user }
          modality1 = set_modality(options.merge(started_on: 1.month.ago))
          modality2 = set_modality(options.merge(started_on: 1.day.ago))
          modality1.reload # gets the change to ended_on caused by adding a successor
          hd_ukrdc_modality_code
          hdf_ukrdc_modality_code

          service.call

          treatments = UKRDC::Treatment.ordered
          expect(treatments.size).to eq(2)
          expect(treatments.first).to have_attributes(
            modality_code_id: hd_ukrdc_modality_code.id,
            clinician_id: user.id,
            patient_id: patient.id,
            started_on: modality1.started_on,
            ended_on: modality1.ended_on
          )

          expect(treatments.last).to have_attributes(
            modality_code_id: hd_ukrdc_modality_code.id,
            clinician_id: user.id,
            patient_id: patient.id,
            started_on: modality2.started_on,
            ended_on: modality2.ended_on
          )
        end
      end

      describe "HD" do
        before do
          hd_ukrdc_modality_code
          hdf_ukrdc_modality_code
        end

        context "when an existing HD patient is assigned an HD profile with hd_type: :hd" do
          it "does not trigger a new Treatment" do
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: 1.month.ago
            )

            hd_profile = create(
              :hd_profile,
              patient: Renalware::HD.cast_patient(patient),
              prescribed_on: 3.weeks.ago,
              by: user
            )
            hd_profile.document.dialysis.hd_type = :hd
            hd_profile.save!

            service.call

            expect(UKRDC::Treatment.count).to eq(1)
          end
        end

        context "when an existing HD patient is assigned an HD profile with hd_type: :hdf_pre" do
          it "trigger a new Treatment" do
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: 1.month.ago
            )

            hd_profile = create(
              :hd_profile,
              patient: Renalware::HD.cast_patient(patient),
              prescribed_on: 3.weeks.ago,
              by: user
            )
            hd_profile.document.dialysis.hd_type = :hdf_pre
            hd_profile.save!

            service.call

            expect(UKRDC::Treatment.count).to eq(2)
          end
        end

        context "when an existing HD patient is assigned an HD profile with hd_type: :hdf_post" do
          it "trigger a new Treatment" do
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: 1.month.ago
            )

            hd_profile = create(
              :hd_profile,
              patient: Renalware::HD.cast_patient(patient),
              prescribed_on: 3.weeks.ago,
              by: user
            )
            hd_profile.document.dialysis.hd_type = :hdf_post
            hd_profile.save!

            service.call

            expect(UKRDC::Treatment.count).to eq(2)
          end
        end
      end
    end
  end
end
