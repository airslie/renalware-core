require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RecipientPresenter, type: :model do
      include LettersSpecHelper

      subject(:main_recipient) { RecipientPresenter.new(letter.main_recipient) }

      describe "#address" do
        context "in state draft" do
          let(:letter) { create_letter_to(:patient, state: :draft) }

          it "returns the address of the person" do
            expect(main_recipient.address).to eq(letter.patient.current_address)
          end
        end

        context "in state ready_for_review" do
          let(:letter) { create_letter_to(:patient, state: :ready_for_review) }

          it "returns the address of the person" do
            expect(main_recipient.address).to eq(letter.patient.current_address)
          end
        end

        context "in state archived" do
          let!(:letter) { create_letter_to(:patient, state: :archived) }

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