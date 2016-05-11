require "rails_helper"

module Renalware
  module Letters
    RSpec.describe LetterFactory, type: :model do
      let(:patient) { build(:letter_patient) }

      subject { LetterFactory.new(patient) }

      describe "#build" do
        it "sets the patients doctor as the main recipient" do
          letter = subject.build

          expect(letter.main_recipient.person_role).to eq("doctor")
        end
      end
    end
  end
end