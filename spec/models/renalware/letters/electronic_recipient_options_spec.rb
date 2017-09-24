require "rails_helper"

module Renalware
  module Letters
    describe ElectronicRecipientOptions do
      include LettersSpecHelper

      let(:patient) { create(:letter_patient, by: author) }
      let(:another_patient) { create(:letter_patient, by: author) }
      let(:author) { create(:user, given_name: "author") }
      let(:recipient1) { create(:user, given_name: "recipient1") }

      describe "#to_a" do
        context "when a user has been a previous e-cc on a letter for a particular patient" do
          it "returns that user in the first group only" do
            letter = create_letter(to: :patient,
                                   patient: patient,
                                   by: author)

            letter.electronic_cc_recipients << recipient1
            letter.save_by!(author)

            options = described_class.new(patient, author)

            group = options.to_a[0]
            expect(group.users).to include(recipient1)
            expect(group.users).to_not include(author)

            group = options.to_a[1]
            expect(group.users).to be_empty

            group = options.to_a[2]
            expect(group.users).to_not include(recipient1)
            expect(group.users).to include(author)
          end
        end

        context "when a user has not been a previous e-cc but for this patient, but has been a "\
                "CC on a letter to another patient by the same author" do

          it "returns that user in the second group only" do
            letter = create_letter(to: :patient,
                                   patient: another_patient,
                                   by: author)

            letter.electronic_cc_recipients << recipient1
            letter.save_by!(author)

            options = described_class.new(patient, author)

            group = options.to_a[0]
            expect(group.users).to be_empty

            group = options.to_a[1]
            expect(group.users).to include(recipient1)
            expect(group.users).to_not include(author)

            group = options.to_a[2]
            expect(group.users).to_not include(recipient1)
            expect(group.users).to include(author)
          end
        end
      end
    end
  end
end
