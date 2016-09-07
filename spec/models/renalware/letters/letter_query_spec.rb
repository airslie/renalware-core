require "rails_helper"

module Renalware
  module Letters
    describe LetterQuery, type: :model do
      include LettersSpecHelper

      let(:primary_care_physician) { create(:letter_primary_care_physician) }
      let(:patient) { create(:letter_patient, primary_care_physician: primary_care_physician) }

      subject { LetterQuery.new }

      describe "#call" do
        before do
          create_letter_in_state(:draft)
          create_letter_in_state(:pending_review)
          create_letter_in_state(:approved)
        end

        context "given no filters" do
          it "returns all letters" do
            expect(subject.call.count).to eq(3)
          end
        end
      end

      private

      def create_letter_in_state(state)
        create_letter(state: state, to: :patient, patient: patient)
      end
    end
  end
end
