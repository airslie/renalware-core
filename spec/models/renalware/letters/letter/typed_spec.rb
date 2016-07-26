require "rails_helper"

module Renalware::Letters
  describe Letter::Typed do
    let(:patient) { double(:patient) }
    let(:user) { build(:user) }

    subject(:letter) { Letter::Typed.new() }

    describe "#archive" do
      it "archives the letter" do
        archived_letter = letter.archive(by: user)
        expect(archived_letter).to be_archived
      end

      it "archives the content" do
        archived_letter = letter.archive(by: user)
        expect(archived_letter.content).to include("<div>")
      end

      it "records who archived the letter" do
        archived_letter = letter.archive(by: user)
        expect(archived_letter.archived_by).to eq(user)
      end
    end
  end
end
