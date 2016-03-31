require "rails_helper"

module Renalware
  module Letters
    RSpec.describe LetterFactory, type: :model do
      let(:patient) { ActiveType.cast(create(:patient), Letters::Patient) }

      subject { LetterFactory.new(patient) }

      describe "#build" do
        it "sets the patients doctor as the main recipient" do
          letter = subject.build

          expect(letter.main_recipient.source_type).to eq("Renalware::Doctor")
        end
      end
    end
  end
end