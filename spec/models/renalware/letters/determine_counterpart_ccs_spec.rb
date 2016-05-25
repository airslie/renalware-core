require "rails_helper"

module Renalware
  module Letters
    RSpec.describe DetermineCounterpartCCs, type: :model do
      include LettersSpecHelper

      subject { DetermineCounterpartCCs.new(letter) }

      let(:patient) { build(:letter_patient) }

      describe "#call" do
        context "given the recipient is the patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it "determines the doctor as a CC recipient" do
            cc_recipients = subject.call
            expect(cc_recipients.size).to eq(1)
            expect(cc_recipients.first.person_role).to eq("doctor")
          end
        end

        context "given the recipient is the doctor" do
          let(:letter) { build_letter(to: :doctor, patient: patient) }

          context "given the patient opted to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(true)
            end

            it "determines the patient as a CC recipient" do
              cc_recipients = subject.call

              expect(cc_recipients.size).to eq(1)
              expect(cc_recipients.first.person_role).to eq("patient")
            end
          end

          context "given the patient did not opt to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(false)
            end

            it "does not determine the patient as a CC recipient" do
              cc_recipients = subject.call

              expect(cc_recipients).to be_empty
            end
          end
        end

        context "given the recipient is someone else" do
          let(:letter) { build_letter(to: :other, patient: patient) }

          context "given the patient opted to be CCd on all letters" do
            before do
              letter.patient.cc_on_all_letters = true
            end

            it "determines the patient and the doctor as CC recipients" do
              cc_recipients = subject.call

              expect(cc_recipients.size).to eq(2)
              person_roles = cc_recipients.map(&:person_role)
              expect(person_roles).to include("patient")
              expect(person_roles).to include("doctor")
            end
          end
        end
      end
    end
  end
end
