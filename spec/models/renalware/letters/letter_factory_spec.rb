require "rails_helper"

module Renalware
  module Letters
    RSpec.describe LetterFactory, type: :model do
      let(:patient) { create(:letter_patient) }

      subject { LetterFactory.new(patient) }

      describe "#build" do
        it "sets the patient's Primary Care Physician as the main recipient" do
          letter = subject.build

          expect(letter.main_recipient.person_role).to eq("primary_care_physician")
        end

        context "given the patient has contacts flagged as default CC" do
          before do
            @default_cc_contact = build(:letter_contact, default_cc: true, person: build(:directory_person, family_name: "default CC"))
            @non_default_cc_contact = build(:letter_contact, default_cc: false, person: build(:directory_person, family_name: "non default CC"))
            patient.contacts = [@non_default_cc_contact, @default_cc_contact]
          end

          context "with contacts as default ccs" do
            it "sets the patient's default CC's" do
              letter = subject.with_contacts_as_default_ccs.build

              recipients = letter.cc_recipients.map(&:addressee)
              expect(recipients.map(&:family_name)).to include(@default_cc_contact.family_name)
              expect(recipients.map(&:family_name)).to_not include(@non_default_cc_contact.family_name)
              letter.cc_recipients.map(&:role).each do |role|
                expect(role).to eq("cc")
              end
            end
          end
        end
      end
    end
  end
end
