require "rails_helper"

module Renalware
  module Transplants
    describe RegistrationStatus do
      it { is_expected.to validate_presence_of(:description_id) }
      it { is_expected.to validate_timeliness_of(:started_on) }
      it { is_expected.to validate_timeliness_of(:terminated_on) }

      describe "#valid?" do
        let(:attributes) { {} }
        subject {
          RegistrationStatus.new(
            attributes_for(:transplant_registration_status).merge(attributes)
          )
        }

        it { is_expected.to be_valid }

        context "given a missing started_on" do
          let(:attributes) { { started_on: nil } }

          it { is_expected.to_not be_valid }
        end

        context "given an invalid started_on" do
          let(:attributes) { { started_on: "99-99-9999" } }

          it { is_expected.to_not be_valid }
        end

        context "given a stated_on in the future" do
          let(:attributes) { { started_on: (Time.zone.today + 1.day) } }

          it { is_expected.to_not be_valid }
        end
      end
    end
  end
end