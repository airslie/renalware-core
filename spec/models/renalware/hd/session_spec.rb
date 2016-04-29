require "rails_helper"

module Renalware
  module HD
    RSpec.describe Session, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:signed_on_by) }
      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:hospital_unit) }
      it { is_expected.to validate_presence_of(:start_time) }

      it { is_expected.to validate_timeliness_of(:performed_on) }
      it { is_expected.to validate_timeliness_of(:start_time) }
      it { is_expected.to validate_timeliness_of(:end_time) }

      let(:nurse) { create(:user) }
      let(:patient) { create(:patient) }
      let(:session) { build(:hd_session, patient: patient, signed_on_by: nurse, by: nurse) }

      it "is valid" do
        expect(session).to be_valid
      end

      describe "#valid?" do

        context "when end_time is prior to start_time" do
          it "is not valid" do
            session.start_time = Time.zone.parse("2016-04-28 12:00")
            session.end_time = Time.zone.parse("2016-04-28 11:00")
            expect(session).to_not be_valid
          end
        end
      end

      context "with a patient in a modality" do
        let!(:modality) { create(:modality) }
        let(:patient) { modality.patient }

        context "when creating the record" do
          it "associates the patient current modality" do
            session.save!
            expect(session.modality_description_id).to eq(modality.id)
          end
        end
      end

      context "with duration" do
        context "when changing end_time" do
          it "computes the duration in minutes" do
            session.end_time = session.start_time + 30.minutes
            session.save!
            expect(session.duration).to eq(30)
          end
        end

        context "when changing start_time" do
          it "computes the duration in minutes" do
            session.end_time = session.start_time + 1.hour
            session.save!

            session.start_time = session.end_time - 30.minutes
            session.save!

            expect(session.duration).to eq(30)
          end
        end
      end
    end
  end
end
