require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RecipientPresenterFactory, type: :model do
      include LettersSpecHelper

      subject(:main_recipient) { RecipientPresenterFactory.new(letter.main_recipient) }

      let(:patient) { build(:letter_patient) }

      describe "#address" do
        context "in state draft" do
          let(:letter) { build_letter(to: :patient, patient: patient, state: :draft) }

          it "returns the address of the person" do
            expect(main_recipient.address).to eq(letter.patient.current_address)
          end
        end

        context "in state ready_for_review" do
          let(:letter) { build_letter(to: :patient, patient: patient, state: :ready_for_review) }

          it "returns the address of the person" do
            expect(main_recipient.address).to eq(letter.patient.current_address)
          end
        end

        context "in state archived" do
          let!(:letter) { build_letter(to: :patient, patient: patient, state: :archived) }

          before do
            letter.patient.current_address.update_attributes!(street_1: "NEW STREET")
          end

          it "returns the address of the person" do
            expect(main_recipient.address).to_not eq(letter.patient.current_address)
            expect(main_recipient.address).to eq(letter.main_recipient.address)
          end
        end
      end
    end
  end
end