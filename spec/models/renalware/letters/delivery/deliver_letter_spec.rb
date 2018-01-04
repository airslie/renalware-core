require "rails_helper"

module Renalware
  describe Letters::Delivery::DeliverLetter do
    let(:gp) { create(:letter_primary_care_physician) }
    let(:patient) { create(:letter_patient, primary_care_physician: gp, cc_on_all_letters: true) }
    let(:user) { create(:user) }
    let(:letter) { build(:approved_letter, patient: patient, by: user) }

    before do
      ActiveJob::Base.queue_adapter = :test
      allow(Letters::Delivery::PostLetterToRecipients).to receive(:call)
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
          described_class.new(letter: letter).call

          expect(Letters::Delivery::EmailLetterToGPJob).not_to have_been_enqueued
          expect(Letters::Delivery::PostLetterToRecipients).not_to have_received(:call)
        end
      end

      context "when the gp is the main_recipient ad the patient is cc'd" do
        it "emails the gp and snailmails the patient" do
          gp_recipient = make_gp_the_main_recipient
          patient_recipient = add_patient_as_cc

          described_class.new(letter: letter).call

          expect(Letters::Delivery::EmailLetterToGPJob)
            .to have_been_enqueued
            .with(letter, gp_recipient)
          expect(Letters::Delivery::PostLetterToRecipients)
            .to have_received(:call)
            .with(letter, [patient_recipient])
        end
      end

      context "when the patient is the main_recipient and the gp is cc'd" do
        it "emails the gp and snailmails the patient" do
          patient_recipient = letter.build_main_recipient(person_role: :patient)
          gp_recipient = add_gp_as_cc

          described_class.new(letter: letter).call

          expect(Letters::Delivery::EmailLetterToGPJob)
            .to have_been_enqueued
            .with(letter, gp_recipient)
          expect(Letters::Delivery::PostLetterToRecipients)
            .to have_received(:call)
            .with(letter, [patient_recipient])
        end
      end
    end
  end
end
