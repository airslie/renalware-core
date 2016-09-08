require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RecipientPresenter::WithCurrentAddress, type: :model do
      include LettersSpecHelper

      subject(:presenter) { RecipientPresenter::WithCurrentAddress.new(recipient) }

      let(:patient) { build(:letter_patient) }
      let(:recipient) { letter.main_recipient }

      describe "#address" do
        context "given the recipient's role is patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it "returns the address of the patient" do
            expect(presenter.address).to eq(letter.patient.current_address)
          end
        end

        context "given the recipient's role is Primary Care Physician" do
          let(:letter) { build_letter(to: :primary_care_physician, patient: patient) }

          it "returns the address of the Primary Care Physician" do
            expect(presenter.address).to eq(letter.patient.primary_care_physician.current_address)
          end
        end

        context "given the recipient's role is other" do
          let(:letter) { build_letter(to: :other, patient: patient) }

          it "returns the recipient's address" do
            expect(presenter.address).to eq(recipient.address)
          end
        end
      end
    end
  end
end
