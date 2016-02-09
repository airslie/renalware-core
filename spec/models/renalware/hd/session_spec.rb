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

      describe "#valid?" do
        let(:session) { build(:hd_session) }

        it "is valid" do
          expect(session).to be_valid
        end

        context "when end_time is prior to start_time" do
          it "is not valid" do
            session.start_time = 1.hour.ago
            session.end_time = 2.hours.ago
            expect(session).to_not be_valid
          end
        end
      end

      context "with a patient in a modality" do
        let!(:modality) { create(:modality) }
        let(:session) { build(:hd_session, patient: modality.patient) }

        context "when creating the record" do
          it "associates the patient current modality" do
            session.by = session.signed_on_by
            session.save!
            expect(session.modality_description_id).to eq(modality.id)
          end
        end
      end
    end
  end
end
