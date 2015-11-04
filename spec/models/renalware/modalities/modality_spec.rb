require "rails_helper"

module Renalware
  describe Modalities::Modality, type: :model do
    it { should belong_to(:modality_description) }
    it { should belong_to(:patient) }
    it { should belong_to(:modality_reason) }
    it { should validate_presence_of :patient }
    it { should validate_presence_of :started_on }
    it { should validate_presence_of :modality_description }

    describe "validate start date based on previous modalities" do
      let!(:another_patients_modality) { create(:modality, started_on: Date.parse("2015-06-02")) }

      context "given there is no previous modality" do
        subject do
          build(:modality, started_on: Date.parse("2015-05-01"))
        end

        it "has a valid start date" do
          subject.valid?
          expect(subject.errors[:started_on]).to be_empty
        end
      end

      context "given there is a previous modality" do
        let!(:patients_modality) { create(:modality, started_on: Date.parse("2015-04-01")) }

        context "given start date is later than previous start date" do
          subject do
            build(:modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-05-01")
            )
          end

          it "has a valid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to be_empty
          end
        end

        context "given start date is not later than previous start date" do
          subject do
            build(:modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-03-21")
            )
          end

          it "has an invalid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to include(/previous modality/)
          end
        end
      end
    end

    describe "#transfer!" do
      subject { create(:modality) }
      let(:started_on) { Date.parse("2015-04-21") }

      before do
        modality_description = FactoryGirl.create(:modality_description, :capd_standard)
        @actual = subject.transfer!(modality_description: modality_description, notes: "Some notes", started_on: started_on)
      end

      it "updates the end date" do
        expect(subject.ended_on).to eq(started_on)
      end

      it "soft deletes the current modality" do
        expect(subject.deleted_at).not_to be_nil
      end

      it "creates a valid modality" do
        expect(@actual).to be_valid
        expect(@actual.notes).to eq("Some notes")
        expect(@actual.started_on).to eq(started_on)
      end
    end

  end
end
