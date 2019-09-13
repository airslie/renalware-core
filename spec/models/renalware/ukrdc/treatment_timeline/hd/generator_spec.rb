# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength
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

      def create_profile(start_date:, end_date: nil, hd_type: :hd, active: true, **args)
        create(
          :hd_profile,
          hd_type, # trait eg :hdf_pre
          patient: patient,
          created_at: start_date,
          deactivated_at: end_date,
          active: active,
          **args
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

        describe "replacating an issue in production" do
          it do
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-06-21"
            )
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-08-10"
            )
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-11-14"
            )
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-12-02"
            )

            hospital_unit1 = create(:hospital_unit)
            hospital_unit2 = create(:hospital_unit)

            # 3 HD profiles but all created on the same day so the last one is the 'effective' one
            create_profile(
              start_date: "2018-03-10 13:02:23.610562", # created_at
              end_date: "2018-04-10 10:57:14.582812", # deactivated_at
              hd_type: :hd,
              active: nil,
              prescribed_on: "2017-06-21",
              hospital_unit: hospital_unit1,
              prescribed_time: 210
            )

            create_profile(
              start_date: "2018-04-10 10:57:14.621685", # created_at
              end_date: "2018-07-07 18:05:00.152214", # deactivated_at
              hd_type: :hd,
              active: nil,
              prescribed_on: "2017-06-21",
              hospital_unit: hospital_unit1,
              prescribed_time: 210
            )

            create_profile(
              start_date: "2018-07-07 18:05:00.163591", # created_at
              end_date: nil, # deactivated_at,
              hd_type: :hd,
              active: true,
              prescribed_on: "2017-06-21",
              hospital_unit: hospital_unit2,
              prescribed_time: 210
            )

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            treatment = UKRDC::Treatment.first
            expect(treatment.hospital_unit).to eq(hospital_unit2)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength
