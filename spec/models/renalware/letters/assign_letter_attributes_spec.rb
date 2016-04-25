require "rails_helper"

module Renalware
  module Letters
    RSpec.describe AssignLetterAttributes, type: :model do
      let(:patient) { create(:letter_patient, cc_on_all_letters: false) }
      let(:letter_trait) { :to_patient }
      let(:letter) { build(:letter, letter_trait) }

      subject { DraftLetter.new(letter) }

      shared_examples_for "Letter" do
        describe ".call" do
          it "assigns the attributes to the letter" do
            subject.call(description: "Foo", by: letter.author)

            expect(letter.description).to eq("Foo")
          end

          it "sets the source instance on the main recipient" do
            subject.call(by: letter.author)

            main_recipient_patient = Letters.cast_patient(letter.main_recipient.source)
            expect(main_recipient_patient).to match(letter.patient)
          end
        end
      end

      context "with a new letter" do
        it_behaves_like "Letter"
      end

      context "with an existing letter" do
        let(:letter) { create(:letter, letter_trait) }

        it_behaves_like "Letter"
      end
    end

  end
end