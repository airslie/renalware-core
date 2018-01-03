require "rails_helper"

module Renalware
  describe Letters::Postman do
    subject(:postman) { described_class.new }
    let(:gp) { create(:letter_primary_care_physician) }
    let(:patient) { create(:letter_patient, primary_care_physician: gp, cc_on_all_letters: true) }
    let(:user) { create(:user) }
    let(:letter) { build(:approved_letter, patient: patient, by: user) }

    before do
      allow(Letters::EmailLetterToGP).to receive(:call)
      allow(Letters::PostLetterToRecipients).to receive(:call)
    end

    def make_gp_the_main_recipient
      gp_recipient = letter.build_main_recipient(person_role: :primary_care_physician)
      letter.save!
      gp_recipient
    end

    def add_gp_as_cc
      gp_recipient = letter.recipients.build(
        role: :cc,
        person_role: :primary_care_physician,
        addressee: gp
      )
      letter.save!
      gp_recipient
    end

    def add_patient_as_cc
      patient_recipient = letter.recipients.build(
        role: :cc,
        person_role: :patient,
        addressee: patient
      )
      letter.save!
      patient_recipient
    end

    describe "#letter_approved" do
      context "when there are no recipients" do
        it "sends nothing out" do
          postman.letter_approved(letter)

          expect(Letters::EmailLetterToGP)
            .not_to have_received(:call)
          expect(Letters::PostLetterToRecipients)
            .not_to have_received(:call)
        end
      end

      context "when the gp is the main_recipient ad the patient is cc'd" do
        it "emails the gp and snailmails the patient" do
          gp_recipient = make_gp_the_main_recipient
          patient_recipient = add_patient_as_cc

          postman.letter_approved(letter)

          expect(Letters::EmailLetterToGP)
            .to have_received(:call)
            .with(letter, gp_recipient)
          expect(Letters::PostLetterToRecipients)
            .to have_received(:call)
            .with(letter, [patient_recipient])
        end
      end

      context "when the patient is the main_recipient and the gp is cc'd" do
        it "emails the gp and snailmails the patient" do
          patient_recipient = letter.build_main_recipient(person_role: :patient)
          gp_recipient = add_gp_as_cc

          postman.letter_approved(letter)

          expect(Letters::EmailLetterToGP)
            .to have_received(:call)
            .with(letter, gp_recipient)
          expect(Letters::PostLetterToRecipients)
            .to have_received(:call)
            .with(letter, [patient_recipient])
        end
      end
    end
  end
end
