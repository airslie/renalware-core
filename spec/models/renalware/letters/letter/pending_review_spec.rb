require "rails_helper"

module Renalware::Letters
  describe Letter::PendingReview do
    include LettersSpecHelper

    let(:user) { build(:user) }
    let(:doctor) { build(:letter_doctor) }
    let(:patient) { build(:letter_patient, doctor: doctor) }
    let(:letter) { build_letter(to: :patient, patient: patient) }

    subject(:letter_pending_review) { letter.becomes(Letter::PendingReview) }

    describe "#archive" do
      it "archives the letter" do
        archived_letter = letter_pending_review.archive(by: user, presenter_class: FakePresenter)
        expect(archived_letter).to be_archived
      end

      context "with persisted letter" do
        let(:doctor) { create(:letter_doctor) } # Doctor has to exist before saving a letter

        before do
          letter.save
        end

        it "records who archived the letter" do
          user = create(:user)
          archived_letter = letter_pending_review.archive(by: user)
          archived_letter.save
          expect(archived_letter.archived_by).to eq(user)
        end

        it "archives the content" do
          archived_letter = letter_pending_review.archive(by: user)
          expect(archived_letter.content).to match(/class="unit-info"/)
          expect(archived_letter.content).to include(patient.full_name)
          expect(archived_letter.content).to include(doctor.address.street_1)
        end
      end

      class FakePresenter
        def initialize(_letter)
        end

        def content
          "hello world"
        end
      end
    end

    describe "#sign" do
      it "creates a signature" do
        letter_pending_review.sign(by: user)
        expect(letter_pending_review.signature).to be_present
        expect(letter_pending_review.signature.user).to eq(user)
      end
    end
  end
end
