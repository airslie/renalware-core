# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
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

        describe "patient has 4 HD modalities in the past but only much newer HD profiles" do
          # Based on 133651
          it "uses the first found hd profile in order to resolve the unit id" do
            modal1 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-06-21"
            )
            modal2 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-08-10"
            )
            modal3 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-11-14"
            )
            modal4 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-12-02"
            )

            unit1 = create(:hospital_unit)
            unit2 = create(:hospital_unit)

            # 3 HD profiles but all created on the same day so the last one is the 'effective' one
            # But note they are not 'in range' of any HD modality so count for nothing
            create_profile(
              start_date: "2018-03-08 18:00:14.760431", # created_at
              end_date: "2018-03-12 11:20:39.431778", # deactivated_at
              hd_type: :hd,
              active: nil,
              prescribed_on: nil,
              hospital_unit: unit1,
              prescribed_time: 210
            )

            create_profile(
              start_date: "2018-03-12 11:20:39.443311", # created_at
              end_date: nil, # deactivated_at
              hd_type: :hd,
              active: true,
              prescribed_on: nil,
              hospital_unit: unit2,
              prescribed_time: 210
            )

            expect {
              described_class.new(modal1).call
              described_class.new(modal2).call
              described_class.new(modal3).call
              described_class.new(modal4).call
            }.to change(UKRDC::Treatment, :count).by(4)

            treatments = UKRDC::Treatment.all

            # The SQL view hd_profile_for_modalities will find the first HD Profile
            # and takes its hospital unit id. No other modalities define in their window
            # a new HD profile that would change the unit id (or hd type)
            expect(treatments.map(&:hospital_unit_id).uniq).to eq [unit1.id]
            expect(treatments.map(&:hd_type).uniq).to eq ["hd"]
          end
        end

        ########################################################################
        ########################################################################
        ########################################################################
        describe "patient has 4 HD modalities and 2 HD profiles" do
          it "uses the first found hd profile in order to resolve the unit id" do
            modal1 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2017-01-01"
            )
            modal2 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2018-01-01"
            )
            modal3 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2019-01-01"
            )
            modal4 = set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: "2020-01-01"
            )

            unit1 = create(:hospital_unit)
            unit2 = create(:hospital_unit)

            # First profile is a year after the first modality, but it is found and used by
            # modality1. The profile lasts fior 1 month then another is created
            create_profile(
              start_date: "2018-02-01", # created_at
              end_date: "2018-03-01", # deactivated_at
              hd_type: :hd,
              active: nil,
              prescribed_on: nil,
              hospital_unit: unit1,
              prescribed_time: 210
            )

            # Change in profile as hd_type has changed
            create_profile(
              start_date: "2018-03-01", # created_at
              end_date: "2018-04-01", # deactivated_at
              hd_type: :hdf_pre, # changed!!
              active: nil,
              prescribed_on: nil,
              hospital_unit: unit1,
              prescribed_time: 210
            )

            create_profile(
              start_date: "2018-04-01", # created_at
              end_date: nil, # deactivated_at = nil so == current profile
              hd_type: :hdf_pre,
              active: true,
              prescribed_on: nil,
              hospital_unit: unit2, # changed
              prescribed_time: 210
            )

            expect {
              described_class.new(modal1.reload).call
              described_class.new(modal2.reload).call
              described_class.new(modal3.reload).call
              described_class.new(modal4.reload).call
            }.to change(UKRDC::Treatment, :count).by(6)

            # The SQL view hd_profile_for_modalities will find the first HD Profile
            # and takes its hospital unit id. No other modalities define in their window
            # a new HD profile that would change the unit id (or hd type)

            treatments = UKRDC::Treatment.all.order(:started_on)

            # Vanilla HD modality (1)
            expect(treatments[0]).to have_attributes(
              started_on: Date.parse("2017-01-01"),
              ended_on: Date.parse("2018-01-01"),
              hd_type: "hd", # from 1st hd profile
              hospital_unit: unit1
            )

            # Vanilla HD modality (2)
            expect(treatments[1]).to have_attributes(
              started_on: Date.parse("2018-01-01"),
              ended_on: Date.parse("2018-03-01"), # end early due to hd_profile change
              hd_type: "hd", # from 1st hd profile
              hospital_unit: unit1
            )

            # Triggered by hd_type change in profile
            expect(treatments[2]).to have_attributes(
              started_on: Date.parse("2018-03-01"),
              ended_on: Date.parse("2018-04-01"), # end here is start of last profile
              hd_type: "hdf_pre",
              hospital_unit: unit1
            )

            # Triggered by hospital unit change in profile
            # Check ended_on not nil ie based on current hd_profile with no deativated date
            # Should be set to previous start date
            expect(treatments[3]).to have_attributes(
              started_on: Date.parse("2018-04-01"),
              ended_on: Date.parse("2019-01-01"),
              hd_type: "hdf_pre",
              hospital_unit: unit2
            )

            # Vanilla HD modality (3)
            expect(treatments[4]).to have_attributes(
              started_on: Date.parse("2019-01-01"),
              ended_on: Date.parse("2020-01-01"),
              hd_type: "hdf_pre",
              hospital_unit: unit2
            )

            # Vanilla HD modality (4)
            expect(treatments[5]).to have_attributes(
              started_on: Date.parse("2020-01-01"),
              ended_on: nil,
              hd_type: "hdf_pre",
              hospital_unit: unit2
            )
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
