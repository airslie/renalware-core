require "rails_helper"

module Renalware
  module Patients
    describe Worry do
      describe "validation" do
        it "validates uniqueness of patient" do
          patient = create(:patient)
          user = create(:user)
          Worry.create!(patient: patient, by: user)

          expect{ Worry.create!(patient: patient, by: user) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe "versioning" do
        with_versioning do
          it "stores a version on creation or deletion" do
            expect(PaperTrail).to be_enabled
            patient = create(:patient)
            user = create(:user)

            worry = Worry.create!(patient: patient, by: user)

            expect(worry.versions.count).to eq(1)

            worry.destroy!

            expect(worry.versions.count).to eq(2)
          end
        end
      end
    end
  end
end
