require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RefreshRecipient, type: :model do
      include LettersSpecHelper

      shared_examples_for "Recipient" do
        it "sets the source instance based on the source type" do
          subject.call(recipient)

          expect(recipient.source).to be_present
        end

        it "copies the name of the source" do
          subject.call(recipient)

          expect(recipient.name).to eq(source.full_name)
        end

        it "copies the address of the source" do
          subject.call(recipient)

          expect(recipient.address).to be_present
          expect(recipient.address.street_1).to eq(source.current_address.street_1)
        end
      end

      let(:letter) { create_letter_to(:patient) }
      let!(:recipient) { create(:letter_recipient, letter: letter, source_type: source.class.name) }

      describe "#call" do
        context "when recipient is a doctor" do
          let(:source) { create(:doctor) }

          it_behaves_like "Recipient"
        end

        context "when recipient is a patient" do
          let(:source) { create(:patient) }

          it_behaves_like "Recipient"
        end
      end
    end
  end
end