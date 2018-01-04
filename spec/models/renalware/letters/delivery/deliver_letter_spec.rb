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
          expect {
            described_class.new(letter: letter).call
          }.not_to have_enqueued_job.on_queue("mailers")
          expect(Letters::Delivery::PostLetterToRecipients).not_to have_received(:call)
        end
      end

      context "when the gp is the main_recipient ad the patient is cc'd" do
        it "emails the gp and snailmails the patient" do
          gp_recipient = make_gp_the_main_recipient
          patient_recipient = add_patient_as_cc

          message_delivery = instance_double(ActionMailer::MessageDelivery, deliver_later: nil)
          allow(Letters::Delivery::PrimaryCarePhysicianMailer)
            .to receive(:patient_letter).with(letter, gp_recipient)
            .and_return(message_delivery)

          described_class.new(letter: letter).call

          expect(message_delivery).to have_received(:deliver_later)
          expect(Letters::Delivery::PostLetterToRecipients)
            .to have_received(:call)
            .with(letter, [patient_recipient])
        end
      end

      context "when the patient is the main_recipient and the gp is cc'd" do
        it "emails the gp and snailmails the patient" do
          patient_recipient = letter.build_main_recipient(person_role: :patient)
          add_gp_as_cc

          # Using a different way of testing the enqueueing here, to create extra coverage
          expect {
            described_class.new(letter: letter).call
          }.to have_enqueued_job.on_queue("mailers")

          expect(Letters::Delivery::PostLetterToRecipients)
            .to have_received(:call)
            .with(letter, [patient_recipient])
        end
      end
    end
  end
end
