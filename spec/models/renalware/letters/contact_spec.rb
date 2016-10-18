require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Contact, type: :model do
      describe "validation" do
        it { is_expected.to validate_presence_of(:person) }

        context "given the person is already a contact for the patient" do
          let(:patient) { create(:letter_patient) }
          let(:person) { create(:directory_person, by: create(:user)) }

          before do
            contact = build_contact(person, patient)
            contact.save!
          end

          it "requires unique person for the patient" do
            new_contact = build_contact(person, patient)
            new_contact.valid?
            expect(new_contact.errors[:person]).to match([/already/])
          end
        end
      end

      def build_contact(person, patient)
        build(:letter_contact, person: person, patient: patient)
      end
    end
  end
end
