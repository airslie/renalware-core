# frozen_string_literal: true

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
      it "raises an error" do
        expect {
          primary_care_physician.current_address
        }.to raise_error(
          Renalware::Patients::PrimaryCarePhysician::PrimaryCarePhysicianAddressAccessError
        )
      end
    end
  end
end
