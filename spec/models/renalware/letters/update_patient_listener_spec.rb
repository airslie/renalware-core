require "rails_helper"

module Renalware
  module Letters
    RSpec.describe UpdatePatientListener, type: :model do
      include LettersSpecHelper

      let(:patient) { letter.patient }
      let(:service_double) { double(call: true) }

      before do
        allow(RefreshRecipient).to receive(:build).and_return(service_double)
      end

      describe "#update_patient_successful" do
        shared_examples_for "PendingLetter" do
          it "refreshes the recipient" do
            expect(service_double).to receive(:call)

            subject.update_patient_successful(patient.reload)
          end
        end

        shared_examples_for "ArchivedLetter" do
          it "refreshes the recipient" do
            expect(service_double).to_not receive(:call)

            subject.update_patient_successful(patient.reload)
          end
        end

        {
          draft: "PendingLetter",
          ready_for_review: "PendingLetter",
          archived: "ArchivedLetter"
        }.each do |letter_state, behavior|
          context "with a #{letter_state} letter" do
            before { expect(letter).to be_valid }

            context "when patient is the main recipient" do
              let(:letter) { create_persisted_letter(:to_patient, letter_state) }
              let(:recipient) { letter.main_recipient }

              it_behaves_like behavior
            end

            context "when patient is CC" do
              let(:letter) { create_persisted_letter(:to_doctor, letter_state) }
              let(:recipient) { letter.cc_recipients.first }

              it_behaves_like behavior
            end
          end
        end
      end
    end
  end
end