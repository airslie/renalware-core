# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    describe TreatmentTimeline::HD::Generator do
      include PatientsSpecHelper
      subject(:generator) { described_class.new(modality) }

      let(:user) { create(:user) }
      let(:hd_ukrdc_modality_code) { create(:ukrdc_modality_code, :hd) }
      let(:hdf_ukrdc_modality_code) { create(:ukrdc_modality_code, :hdf) }
      let(:hd_mod_desc) { create(:hd_modality_description) }
      let(:patient) { create(:patient) }
      let(:modality) do
        set_modality(
          patient: patient,
          modality_description: hd_mod_desc,
          by: user
        )
      end

      def create_profile(start_date:, end_date: nil, hd_type: :hd, active: true)
        create(
          :hd_profile,
          hd_type, # trait eg :hdf_pre
          patient: patient,
          created_at: start_date,
          deactivated_at: end_date,
          active: active
        )
      end

      before do
        hd_ukrdc_modality_code
        hdf_ukrdc_modality_code
      end

      context "when the patient has the HD modality" do
        let(:patient) { create(:hd_patient) }

        context "when they have no HD profile" do
          it "creates one Treatment with a generic UKRDC treatment code of HD" do
            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              patient_id: patient.id,
              hd_profile_id: nil,
              modality_code: hd_ukrdc_modality_code,
              modality_description_id: hd_mod_desc.id,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_id: modality.id
            )
          end
        end

        context "when they have an HD Profile active at the point of modality creation" do
          it "creates uses the regime type when creating the Treatment" do
            create_profile(start_date: 5.years.ago, end_date: nil, hd_type: :hdf_pre)

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              modality_code: hdf_ukrdc_modality_code
            )
          end
        end

        context "when they have an HD Profile created within 100yrs of the modality start date" do
          it "finds this initial profile, regardless of how far in the future it is, and "\
              "uses its type etc when creating the Treatment" do
            create_profile(start_date: Time.zone.now + 99.years, end_date: nil, hd_type: :hdf_pre)

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              modality_code: hdf_ukrdc_modality_code
            )
          end
        end

        context "when 2 HD profiles (HDF then HD) created after the modality start date" do
          it "uses the first for the initial Treatment and creates "\
              "a futher Treatment to register the change from HDF to HD" do
            # The first profile - this will be associated with the modality when creating
            # the first treatment record - is the treatment record will use its HD type etc
            create_profile(
              start_date: Time.zone.now,
              end_date: Time.zone.now + 1.year,
              hd_type: :hdf_pre,
              active: false
            )
            last_hd_profile = create_profile(
              start_date: Time.zone.now + 1.year,
              end_date: nil,
              hd_type: :hd
            )

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(2)

            treatments = UKRDC::Treatment.order(started_on: :asc)
            expect(treatments[0]).to have_attributes(
              modality_code: hdf_ukrdc_modality_code,
              started_on: modality.started_on,
              ended_on: last_hd_profile.created_at.to_date
            )
            expect(treatments[1]).to have_attributes(
              modality_code: hd_ukrdc_modality_code,
              started_on: last_hd_profile.created_at.to_date,
              ended_on: nil
            )
          end
        end
      end
    end
  end
end
