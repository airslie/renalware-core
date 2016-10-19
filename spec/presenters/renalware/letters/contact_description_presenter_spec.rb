require "rails_helper"

module Renalware
  module Letters
    describe ContactDescriptionPresenter do

      describe "#name" do
        context "given a specified description" do
          subject(:presenter) { ContactPresenter.new(specified_contact_description) }
          let(:specified_contact_description) { build(:letter_contact_description) }

          it "presents " do
            expect(presenter.description_name).to eq(specified_contact_description.name)
          end
        end

        context "given an unspecified description" do
          let(:unspecified_contact_description) { build(:letter_contact_description, :unspecified) }

          before do
            contact.description = unspecified_contact_description
            contact.other_description = "Great Uncle"
          end

          it "expects the contact name description to concatenate the contact's other description and the description's name" do
            expect(presenter.description_name).to match(unspecified_contact_description.name)
            expect(presenter.description_name).to match(contact.other_description)
          end
        end
      end
    end
  end
end
