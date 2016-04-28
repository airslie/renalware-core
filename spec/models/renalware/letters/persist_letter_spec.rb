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

          it "notifies a listener the letter was persisted successfully" do
            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(letter)

            expect(listener).to have_received(:persist_letter_successful).with(instance_of(Letter))
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
    end
  end
end