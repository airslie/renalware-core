require "rails_helper"

module Renalware
  module Letters
    RSpec.describe LetterFactory, type: :model do
      subject { LetterFactory.new(patient) }

      let(:patient) { create(:letter_patient) }

      describe "#build" do
        it "sets the patient as the main recipient if no Primary Care Physician present" do
          letter = subject.build

          expect(letter.main_recipient.person_role).to eq("patient")
        end

        it "sets the patient's Primary Care Physician as the main recipient if present" do
          patient.primary_care_physician = create(:letter_primary_care_physician)

          letter = subject.build

          expect(letter.main_recipient.person_role).to eq("primary_care_physician")
        end

        context "given the patient has contacts flagged as default CC" do
          let(:default_cc_contact) do
            build(
              :letter_contact,
              default_cc: true,
              person: build(
                :directory_person,
                family_name: "default CC"
              )
            )
          end

          let(:non_default_cc_contact) do
            build(
              :letter_contact,
              default_cc: false,
              person: build(
                :directory_person,
                family_name: "non default CC"
              )
            )
          end

          before do
            patient.contacts = [non_default_cc_contact, default_cc_contact]
          end

          context "with contacts as default ccs" do
            it "sets the patient's default CC's" do
              letter = subject.with_contacts_as_default_ccs.build

              addressees = letter.cc_recipients.map(&:addressee)
              expect(addressees).to include(default_cc_contact)
              expect(addressees).not_to include(non_default_cc_contact)
            end
          end
        end
      end
    end
  end
end
