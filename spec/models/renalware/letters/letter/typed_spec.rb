require "rails_helper"

module Renalware::Letters
  describe Letter::Typed do
    let(:patient) { double(:patient) }
    let(:user) { build(:user) }

    subject(:letter) { Letter::Typed.new() }

    describe "#archive" do
      it "archives the letter" do
        letter = subject.archive(by: user)
        expect(letter).to be_archived
      end

      it "archives the content" do
        letter = subject.archive(by: user)
        expect(letter.content).to include("<div>")
      end

      it "records who archived the letter" do
        letter = subject.archive(by: user)
        expect(letter.archived_by).to eq(user)
      end
    end
  end
end
