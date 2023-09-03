# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    describe Worry do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to respond_to(:notes)
        is_expected.to belong_to(:patient).touch(true)
      end

      describe "validation" do
        it "validates uniqueness of patient" do
          user = create(:user)
          patient = create(:patient, by: user)

          described_class.create!(patient: patient, by: user)

          expect { described_class.create!(patient: patient, by: user) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe "versioning" do
        with_versioning do
          it "stores a version on creation or deletion" do
            expect(PaperTrail).to be_enabled
            user = create(:user)
            patient = create(:patient, by: user)

            worry = described_class.create!(patient: patient, by: user)

            expect(worry.versions.count).to eq(1)

            worry.destroy!

            expect(worry.versions.count).to eq(2)
          end
        end
      end
    end
  end
end
