require "rails_helper"

module Renalware::Letters
  describe Letter::Typed do
    let(:patient) { double(:patient) }
    let(:user) { double(:user) }

    subject(:letter) { Letter::Typed.new() }

    describe "#archive" do
      it "creates an Archived letter" do
        letter = subject.archive(by: user)
        expect(letter).to be_a(Letter::Archived)
      end

      it "archives a copy of the letter" do
        letter = subject.archive(by: user)
        expect(letter.archived_copy).to include(".letter-preview")
      end
    end
  end
end
