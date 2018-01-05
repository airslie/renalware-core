require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Delivery::PracticeMailer, type: :mailer do
      subject(:mail) { described_class.patient_letter(letter) }

      describe "patient_letter" do
        let(:practice) { create(:practice, email: "#{SecureRandom.hex(10)}@example.com") }
        let(:gp) { create(:letter_primary_care_physician, practices: [practice]) }
        let(:patient) do
          create(
            :letter_patient,
            primary_care_physician: gp,
            practice: practice
          )
        end
        let(:user) { create(:user, email: "user@renalware.com") }
        let(:letter) do
          build(:approved_letter, patient: patient, by: user).tap do |letter|
            letter.build_main_recipient(person_role: :primary_care_physician, addressee: gp)
            letter.save!
          end
        end
        let(:fake_pdf){ "%PDF-1.4\n1" }

        before do
          allow(PdfLetterCache).to receive(:fetch).and_return(fake_pdf)
        end

        describe "error checking" do
          it "raises an error if the patient has no practice" do
            patient.update!(practice: nil, by: user)

            expect{
              mail.subject
            }.to raise_error(Delivery::PatientHasNoPracticeError)
          end

          it "raises an error if practice has no email address" do
            practice.update!(email: nil)

            expect{
              mail.subject
            }.to raise_error(Delivery::PracticeHasNoEmailError)
          end
        end

        it "renders the headers" do
          Renalware.configure do |config|
            config.default_from_email_address = "test@example.com"
            config.allow_external_mail = true
          end

          expect(mail.subject).to eq("Test")
          expect(mail.to).to eq([practice.email])
          expect(mail.from).to eq(["test@example.com"])
        end

        context "when the interceptor email address is set" do
          it "sends only to the interceptor" do
            Renalware.configure do |config|
              config.allow_external_mail = false
            end
            expect(mail.to).to eq(["user@renalware.com"])
          end
        end

        it "renders the body" do
          expect(mail.body.encoded).to match("<IDENT>")
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
