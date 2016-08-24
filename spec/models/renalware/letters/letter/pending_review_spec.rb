require "rails_helper"

module Renalware::Letters
  describe Letter::PendingReview do
    include LettersSpecHelper

    let(:user) { build(:user) }
    let(:doctor) { build(:letter_doctor) }
    let(:patient) { build(:letter_patient, doctor: doctor) }
    let(:raw_letter) { build_letter(to: :patient, patient: patient) }

    subject(:letter) { raw_letter.becomes(Letter::PendingReview) }

    describe "#sign" do
      it "creates a signature" do
        now = Time.zone.parse("2004-11-24 01:04:44")
        travel_to now

        signature = letter.sign(by: user).signature

        expect(signature).to be_present
        expect(signature.user).to eq(user)
        expect(signature.signed_at).to eq(now)
      end
    end

    describe "#archive" do
      let(:presenter) { double(:presenter, content: "hello world") }

      it "archives the letter" do
        archived_letter = letter.archive(by: user, presenter: presenter)
        expect(archived_letter).to be_archived
      end

      context "given the letter is persisted" do
        let(:doctor) { create(:letter_doctor) } # Doctor has to exist before saving a letter

        before do
          raw_letter.save
        end

        it "records who archived the letter" do
          user = create(:user)
          archived_letter = letter.archive(by: user)
          archived_letter.save
          expect(archived_letter.archived_by).to eq(user)
        end

        it "archives the content" do
          archived_letter = letter.archive(by: user)
          expect(archived_letter.content).to match(/class="unit-info"/)
          expect(archived_letter.content).to include(patient.full_name)
          expect(archived_letter.content).to include(doctor.address.street_1)
        end
      end
    end
  end
end
