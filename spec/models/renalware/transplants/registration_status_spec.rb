require "rails_helper"

module Renalware
  module Transplants
    describe RegistrationStatus do
      let(:clinician) { create(:user, :clinician) }

      describe "#valid?" do
        subject { build(:transplant_registration_status, overrides).valid? }
        let(:overrides) { {} }

        context "with missing started_on" do
          let(:overrides) { {started_on: nil} }
          it { is_expected.to be_falsy }
        end

        context "with invalid started_on" do
          let(:overrides) { {started_on: "99-99-9999"} }
          it { is_expected.to be_falsy }
        end
      end

      describe "#whodunnit_name" do
        subject { RegistrationStatus.new(attributes).whodunnit_name }
        let(:attributes) { {} }

        context "with empty whodunnit" do
          it { is_expected.to eq("System") }
        end

        context "with whodunnit set to an existing user id" do
          let(:attributes) { {whodunnit: clinician.id} }
          it { is_expected.to eq(clinician.name) }
        end

        context "with whodunnit set to non-existing user id" do
          let(:attributes) { {whodunnit: 999} }
          it { is_expected.to eq("User 999") }
        end
      end
    end
  end
end