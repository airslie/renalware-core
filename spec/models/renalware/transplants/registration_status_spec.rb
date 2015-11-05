require "rails_helper"

module Renalware
  module Transplants
    describe RegistrationStatus do
      let(:clinician) { create(:user, :clinician) }

      describe "#valid?" do
        let(:attributes) { {} }
        subject { build(:transplant_registration_status, attributes) }

        it { is_expected.to be_valid }

        context "given a missing started_on" do
          let(:attributes) { {started_on: nil} }
          it { is_expected.to_not be_valid }
        end

        context "given an invalid started_on" do
          let(:attributes) { {started_on: "99-99-9999"} }
          it { is_expected.to_not be_valid }
        end
      end
    end
  end
end