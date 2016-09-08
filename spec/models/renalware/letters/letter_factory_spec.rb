require "rails_helper"

module Renalware
  module Letters
    RSpec.describe LetterFactory, type: :model do
      let(:patient) { build(:letter_patient) }

      subject { LetterFactory.new(patient) }

      describe "#build" do
        it "sets the patient's Primary Care Physician as the main recipient" do
          letter = subject.build

          expect(letter.main_recipient.person_role).to eq("primary_care_physician")
        end
      end
    end
  end
end
