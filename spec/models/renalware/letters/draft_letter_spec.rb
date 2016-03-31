require "rails_helper"

module Renalware
  module Letters
    RSpec.describe DraftLetter, type: :model do
      let(:patient) { create(:letter_patient, cc_on_all_letters: false) }
      let(:letter_trait) { :to_patient }

      subject { DraftLetter.new(letter) }

      shared_examples_for "Letter" do
        describe ".call" do
          let(:attributes) { letter.attributes.merge(by: letter.author) }

          it "assign attributes to the letter" do
            allow(letter).to receive(:valid?).and_return(false)
            expect_command_to_be_called(AssignLetterAttributes).and_return(letter)

            subject.call(attributes)
          end

          it "returns a letter instance" do
            expect(subject.call(attributes)).to be_a(Renalware::Letters::Letter)
          end

          context "with an invalid letter" do
            let(:attributes) { letter.attributes.merge(issued_on: nil) }

            it "does not assign the CCs if the letter is invalid" do
              expect(AssignAutomaticRecipients).to_not receive(:new)

              subject.call(attributes)
            end
          end

          context "with a valid letter" do
            it "saves the letter" do
              letter.issued_on += 1.day

              subject.call(attributes)

              expect(letter.errors).to be_blank
              expect(letter).to be_persisted
            end

            it "refreshes the dynamic data in the letter" do
              expect_command_to_be_called(RefreshLetter)

              subject.call(attributes)
            end

            it "assigns the automatic CC recipients" do
              expect_command_to_be_called(AssignAutomaticRecipients)

              subject.call(attributes)
            end
          end
        end
      end

      context "with a new letter" do
        let(:letter) { build(:letter, letter_trait) }

        it_behaves_like "Letter"
      end

      context "with an existing letter" do
        let(:letter) { create(:letter, letter_trait) }

        it_behaves_like "Letter"
      end

      def expect_command_to_be_called(klass)
        allow(klass).to receive(:new).and_return(command = double)
        expect(command).to receive(:call)
      end
    end
  end
end