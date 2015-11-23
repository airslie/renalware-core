require "rails_helper"

module Renalware
  module Transplants
    describe Donation do
      it { is_expected.to validate_presence_of(:state) }
      it { is_expected.to validate_presence_of(:relationship_with_recipient) }

      it { is_expected.to validate_timeliness_of(:volunteered_on) }
      it { is_expected.to validate_timeliness_of(:first_seen_on) }
      it { is_expected.to validate_timeliness_of(:workup_completed_on) }
      it { is_expected.to validate_timeliness_of(:donated_on) }

      describe "#valid?" do
        let(:attributes) { {} }
        subject {
          Donation.new(
            attributes_for(:transplant_donation).merge(attributes)
          )
        }

        it { is_expected.to be_valid }

        context "given relationship is other and relationship is not supplied" do
          let(:attributes) {
            {
              state: :other_living_non_related,
              relationship_with_recipient_other: nil
            }
          }

          it { is_expected.to_not be_valid }
        end

        context "when assigning itself as a recipient" do
          let(:attributes) {
            {
              patient_id: 1,
              recipient_id: 1
            }
          }

          it { is_expected.to_not be_valid }
        end
      end
    end
  end
end
