# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe SlotRequest do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to be_versioned
        is_expected.to belong_to(:patient)
        is_expected.to belong_to(:deletion_reason)
        is_expected.to validate_presence_of(:patient_id)
        is_expected.to validate_presence_of(:urgency)
      end

      describe "uniqueness" do
        subject { described_class.new(patient_id: patient.id, by: user, urgency: "urgent") }

        let(:patient) { create(:patient) }
        let(:user) { create(:user) }

        it "is scoped so only 1 patient_id possible where deleted_at and allocated_at are null" do
          is_expected.to validate_uniqueness_of(:patient_id).scoped_to([:deleted_at, :allocated_at])
        end
      end
    end
  end
end
