require "rails_helper"

module Renalware
  module Letters
    RSpec.describe PersistLetter, type: :model do
      include LettersSpecHelper

      let(:letter) { build_letter_to(:patient) }

      describe ".call" do
        context "with a valid letter" do
          it "saves the letter" do
            subject.call(letter)

            expect(letter.errors).to be_blank
            expect(letter).to be_persisted
          end

          it "broadcasts :persist_letter_successful" do
            expect_subject_to_broadcast(:persist_letter_successful, instance_of(Letter))

            subject.call(letter)
          end
        end

        context "with an invalid letter" do
          it "throws an ActiveRecord::RecordInvalid exception" do
            expect {
              allow(letter).to receive(:valid?).and_return(false)
              subject.call(letter)
            }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end
      end

      def expect_subject_to_broadcast(*args)
        expect(subject).to receive(:broadcast).with(*args)
      end
    end
  end
end