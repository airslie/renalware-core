require "rails_helper"

module Renalware::Letters
  describe Letter::Archived do
    let(:patient) { double(:patient) }
    let(:user) { build(:user) }

    subject(:letter) { Letter::Archived.new() }

    describe "#record_archive" do
      it "creates an archive record" do
        subject.record_archive(by: user)
        expect(subject.archive).to be_present
        expect(subject.archive.created_by).to eq(user)
      end

      it "stores the letter as HTML in the content attributes" do
        subject.record_archive(by: user)
        expect(subject.archive.content).to include("<div>")
      end
    end
  end
end
