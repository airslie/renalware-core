# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Delivery::PracticeMailer, type: :mailer do
      subject(:mail) do
        described_class.patient_letter(letter: letter, to: recipient_email, recipient: recipient)
      end
      let(:recipient_email) { "practice@example.com" }
      let(:recipient) { instance_double(Letters::Recipient) }

      before do
        allow(PdfLetterCache).to receive(:fetch).and_return(fake_pdf)
      end

      describe "patient_letter" do
        let(:practice) { create(:practice, email: "#{SecureRandom.hex(10)}@example.com") }
        let(:gp) { create(:letter_primary_care_physician, practices: [practice]) }
        let(:patient) do
          create(
            :letter_patient,
            primary_care_physician: gp,
            practice: practice,
            local_patient_id: 123123 # KCH
          )
        end
        let(:user) { create(:user, email: "user@renalware.com") }
        let(:letter) do
          build(:approved_letter,
                patient: patient,
                description: "LetterDescription",
                by: user).tap do |letter|
            letter.build_main_recipient(person_role: :primary_care_physician, addressee: gp)
            letter.type ||= letter.class.sti_name # TODO: RSpec timing makes this required
            letter.save!
          end
        end
        let(:fake_pdf){ "%PDF-1.4\n1" }
        let(:recipient) { letter.main_recipient }

        describe "error checking" do
          it "raises an error if the patient has no practice" do
            patient.update!(practice: nil, by: user)

            expect{
              mail.subject
            }.to raise_error(Delivery::PatientHasNoPracticeError)
          end
        end

        it "renders the subject" do
          Renalware.configure do |config|
            config.renal_unit_on_letters = "RenalUnit"
          end
          expect(mail.subject).to eq("LetterDescription from RenalUnit KCH: 123123")
        end

        it "renders the headers" do
          Renalware.configure do |config|
            config.allow_external_mail = true
            config.default_from_email_address = "test@example.com"
          end

          expect(mail.to).to eq([recipient_email])
          expect(mail.from).to eq(["test@example.com"])
        end

        it "renders the body with the correct variables" do
          Renalware.configure do |config|
            config.default_from_email_address = "x@x.com"
            config.phone_number_on_letters = "789789"
          end

          # Note full IDENT tests in practice_email_meta_data_spec.rb
          expect(mail.body.encoded).to match("<IDENT>")
          expect(mail.body.encoded).to match("789789")
          expect(mail.body.encoded).to match("x@x.com")
        end

        it "has a pdf letter attachment" do
          expect(mail.attachments.count).to eq(1)
          attachment = mail.attachments.first
          expect(attachment).to be_a_kind_of(Mail::Part)
          expect(attachment.content_type).to match("application/pdf")
          expect(attachment.filename).to eq("letter.pdf")
        end
      end
    end
  end
end
