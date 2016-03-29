require "rails_helper"

module Renalware
  module Letters
    RSpec.describe DraftLetter, type: :model do
      let(:patient) { create(:letter_patient, cc_on_all_letters: false) }
      let(:letter_trait) { :to_patient }

      subject { DraftLetter.new(letter) }

      shared_examples_for "LetterWithCCs" do
        describe ".call" do
          let(:attributes) { letter.attributes.merge(by: letter.author) }

          it "returns a letter instance" do
            expect(subject.call(attributes)).to be_a(Renalware::Letters::Letter)
          end

          it "saves the letter" do
            letter.issued_on += 1.day

            subject.call(attributes)

            expect(letter.errors).to be_blank
            expect(letter).to be_persisted
          end

          it "does not assign the CCs if the letter is invalid" do
            letter.issued_on = nil

            expect {
              subject.call(attributes)
            }.to_not change {
              letter.cc_recipients.size
            }
          end

          context "when recipient is the patient" do
            let(:letter_trait) { :to_patient }

            it "adds the doctor as a CC recipient" do
              subject.call(attributes)

              expect(letter.cc_recipients.count).to eq(1)
              expect(letter.cc_recipients.first.source.id).to eq(letter.patient.doctor.id)
            end
          end

          context "when recipient is the doctor" do
            let(:letter_trait) { :to_doctor }

            context "when patient opted to be CCd on all letters" do
              before do
                letter.patient.cc_on_all_letters = true
              end

              it "adds the patient as a CC recipient" do
                subject.call(attributes)

                expect(letter.cc_recipients.count).to eq(1)
                expect(letter.cc_recipients.first.source.id).to eq(letter.patient.id)
              end
            end

            context "when patient did not opt to be CCd on all letters" do
              before do
                letter.patient.cc_on_all_letters = false
              end

              it "does not add the patient as a CC recipient" do
                subject.call(attributes)

                expect(letter.cc_recipients.count).to eq(0)
              end
            end
          end

          context "when recipient is someone else" do
            let(:letter_trait) { :to_someone_else }

            context "when patient opted to be CCd on all letters" do
              before do
                letter.patient.cc_on_all_letters = true
              end

              it "adds the patient and the doctor as CC recipients" do
                subject.call(attributes)

                expect(letter.cc_recipients.count).to eq(2)
                sources = letter.cc_recipients.map(&:source)
                expect(sources).to include(letter.patient)
                expect(sources).to include(letter.patient.doctor)
              end
            end
          end

        end
      end

      context "with a new letter" do
        let(:letter) { build(:letter, letter_trait) }

        it_behaves_like "LetterWithCCs"
      end

      context "with an existing letter" do
        let(:letter) { create(:letter, letter_trait) }

        it_behaves_like "LetterWithCCs"
      end
    end

  end
end