require 'rails_helper'
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Doctor, type: :model do
    subject(:doctor) { create(:doctor) }

    it_behaves_like 'Personable'

    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :practitioner_type }

    describe "#current_address" do
      context "when doctor has an alternate address" do
        it "returns the alternate address" do
          expect(doctor.current_address).to eq(doctor.address)
        end
      end

      context "when doctor does not have an alternate address" do
        let(:practice) { create(:practice) }
        subject(:doctor) { create(:doctor, address: nil, practices: [practice]) }

        it "returns the address of the first practice" do
          expect(doctor.current_address).to eq(practice.address)
        end

        it "adds the doctor's name to the address" do
          expect(doctor.current_address.name).to eq("Dr " + doctor.full_name)
        end
      end
    end
  end
end
