require "rails_helper"

module Renalware
  module Letters
    describe ContactPresenter do
      let(:contact) { build(:letter_contact) }
      subject(:presenter) { ContactPresenter.new(contact) }

      describe "#description_name" do
        context "given a specified description" do
          let(:specified_contact_description) { build(:letter_contact_description) }

          before do
            contact.description = specified_contact_description
          end

          it "presents the original description name" do
            expect(presenter.description_name).to eq(specified_contact_description.name)
          end
        end

        context "given an unspecified description" do
          let(:unspecified_contact_description) { build(:letter_contact_description, :unspecified) }

          before do
            contact.description = unspecified_contact_description
            contact.other_description = "Great Uncle"
          end

          it "presents the original description name with the contact's other description" do
            expect(presenter.description_name).to match(unspecified_contact_description.name)
            expect(presenter.description_name).to match(contact.other_description)
          end
        end
      end
    end
  end
end
