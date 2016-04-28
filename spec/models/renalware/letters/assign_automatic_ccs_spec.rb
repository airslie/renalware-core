require "rails_helper"

module Renalware
  module Letters
    RSpec.describe AssignAutomaticCcs, type: :model do
      include LettersSpecHelper

      describe ".call" do
        let(:attributes) { letter.attributes.merge(by: letter.author) }

        context "when recipient is the patient" do
          let(:letter) { create_letter_to(:patient) }

          it "adds the doctor as a CC recipient" do
            subject.call(letter)
            expect(letter.cc_recipients.size).to eq(1)
            expect(letter.cc_recipients.first.source.id).to eq(letter.patient.doctor.id)
          end
        end

        context "when recipient is the doctor" do
          let(:letter) { create_letter_to(:doctor) }

          context "when patient opted to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(true)
            end

            it "adds the patient as a CC recipient" do
              subject.call(letter)

              expect(letter.cc_recipients.size).to eq(1)
              expect(letter.cc_recipients.first.source.id).to eq(letter.patient.id)
            end
          end

          context "when patient did not opt to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(false)
            end

            it "does not add the patient as a CC recipient" do
              subject.call(letter)

              expect(letter.cc_recipients.size).to eq(0)
            end
          end
        end

        context "when recipient is someone else" do
          let(:letter) { create_letter_to(:someone_else) }

          context "when patient opted to be CCd on all letters" do
            before do
              letter.patient.cc_on_all_letters = true
            end

            it "adds the patient and the doctor as CC recipients" do
              subject.call(letter)

              expect(letter.cc_recipients.size).to eq(2)
              sources = letter.cc_recipients.map(&:source)
              expect(sources).to include(letter.patient)
              expect(sources).to include(letter.patient.doctor)
            end
          end
        end
      end
    end
  end
end