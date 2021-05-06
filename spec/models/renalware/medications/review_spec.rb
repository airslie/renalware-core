# frozen_string_literal: true

require "rails_helper"

module Renalware::Medications
  describe Review, type: :model do
    it_behaves_like "an Accountable model"

    it :aggregate_failures do
      is_expected.to belong_to :patient
      is_expected.to validate_presence_of :patient
    end

    describe ".latest" do
      it "returns the last review event for the patient" do
        event_type = create(:medication_review_event_type)
        user = create(:user)
        patient = create(:patient, by: user)

        target_review = described_class.create!(
          patient: patient,
          by: user,
          date_time: 1.day.ago,
          event_type: event_type
        )

        described_class.create!(
          patient: patient,
          by: user,
          date_time: 2.days.ago,
          event_type: event_type
        )

        expect(patient.medication_reviews.latest).to eq(target_review)
      end
    end
  end
end
