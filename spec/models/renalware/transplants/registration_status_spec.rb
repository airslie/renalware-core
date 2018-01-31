require "rails_helper"

module Renalware
  module Transplants
    describe RegistrationStatus do
      it_behaves_like "an Accountable model"
      it { is_expected.to belong_to(:registration).touch(true) }
      it { is_expected.to validate_presence_of(:description_id) }
      it { is_expected.to validate_timeliness_of(:started_on) }
      it { is_expected.to validate_timeliness_of(:terminated_on) }

      describe "#valid?" do
        subject {
          RegistrationStatus.new(
            attributes_for(:transplant_registration_status).merge(attributes)
          )
        }

        let(:attributes) { {} }

        it { is_expected.to be_valid }

        context "when started_on missing" do
          let(:attributes) { { started_on: nil } }

          it { is_expected.not_to be_valid }
        end

        context "when started_on is invalid" do
          let(:attributes) { { started_on: "99-99-9999" } }

          it { is_expected.not_to be_valid }
        end

        context "when stated_on is in the future" do
          let(:attributes) { { started_on: (Time.zone.today + 1.day) } }

          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
