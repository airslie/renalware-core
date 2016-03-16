require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Recipient, type: :model do
      describe ".new" do
        it "applies defaults" do
          recipient = subject.class.new

          expect(recipient.source_type).to eq("Renalware::Doctor")
        end
      end
    end
  end
end