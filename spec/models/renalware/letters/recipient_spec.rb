# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Recipient, type: :model do
      #
      it { is_expected.to respond_to(:emailed_at) }
      it { is_expected.to respond_to(:printed_at) }

      describe "#addressee_id" do
        describe "validation" do
          it "validates presence if person is a contact" do
            recipient = described_class.new(person_role: "contact")
            expect(recipient).to validate_presence_of(:addressee_id)
          end
        end
      end
    end
  end
end
