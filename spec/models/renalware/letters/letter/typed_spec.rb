require "rails_helper"

module Renalware::Letters
  describe Letter::Typed do
    let(:patient) { double(:patient) }
    let(:user) { build(:user) }

    subject(:letter) { Letter::Typed.new() }

    describe "#archive" do
      it "creates an Archived letter" do
        letter = subject.archive(by: user)
        expect(letter).to be_a(Letter::Archived)
      end
    end
  end
end
