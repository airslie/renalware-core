require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware::Patients
  describe PrimaryCarePhysician, type: :model do
    subject(:primary_care_physician) { create(:primary_care_physician) }
    it { is_expected.to have_many(:practice_memberships) }
    it { is_expected.to have_many(:practices).through(:practice_memberships) }

    it_behaves_like "a Paranoid model"

    describe "validation" do
      it { is_expected.to validate_uniqueness_of :code }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :practitioner_type }
    end

    describe "#current_address" do
      context "when Primary Care Physician has an alternate address" do
        it "returns the alternate address" do
          expect(primary_care_physician.current_address).to eq(primary_care_physician.address)
        end
      end

      context "when Primary Care Physician does not have an alternate address" do
        subject(:primary_care_physician) { create(:primary_care_physician, practices: [practice]) }

        let(:practice) { create(:practice) }

        before do
          primary_care_physician.address.delete
          primary_care_physician.reload
        end

        it "returns the address of the first practice" do
          expect(primary_care_physician.current_address).to eq(practice.address)
        end

        it "adds the Primary Care Physician's name to the address" do
          expect(primary_care_physician.current_address.name).to(
            eq("Dr " + primary_care_physician.name)
          )
        end
      end
    end
  end
end
