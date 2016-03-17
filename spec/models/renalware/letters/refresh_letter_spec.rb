require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RefreshLetter, type: :model do
      let(:letter) { create(:letter) }
      let(:main_recipient) { letter.main_recipient }

      describe "#call" do
        context "when source is a doctor" do
          let(:letter) { create(:letter_to_doctor) }

          it "copies the doctor's name and current address" do
            expect_main_recipient_refreshed(letter.patient.doctor)
          end
        end

        context "when source is the patient" do
          let(:letter) { create(:letter_to_patient) }

          it "copies the doctor's name and current address" do
            expect_main_recipient_refreshed(letter.patient)
          end
        end
      end

      def expect_main_recipient_refreshed(source)
        RefreshLetter.new(letter).call

        expect(main_recipient.name).to eq(source.full_name)
        expect(main_recipient.address).to be_present
        expect(main_recipient.address.street_1).to eq(source.current_address.street_1)
      end
    end
  end
end