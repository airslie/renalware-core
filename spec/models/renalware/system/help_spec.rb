# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe System::Help, type: :model do
    it_behaves_like "a Paranoid model"
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:name) }

    describe "uniqueness" do
      subject { described_class.new(by: create(:user)) }

      it { is_expected.to validate_uniqueness_of(:name) }
    end

    describe "#file via ActiveStorage" do
      subject(:help) { create(:system_help) }

      let(:user) { help.updated_by }

      it "can accept an uploaded file" do
        help.file.attach(
          io: File.open(file_fixture("README.md")),
          filename: "README.md",
          content_type: "text/markdown; charset=UTF-8"
        )
        help.save_by!(user)

        expect(help.file).to be_attached
      end

      it "validates the presence of #file" do
        help_item = build(:system_help, file: nil)

        expect(help_item).not_to be_valid
        expect(help_item.errors.first).to eq([:file, "Please specify a file to upload"])
      end
    end
  end
end
