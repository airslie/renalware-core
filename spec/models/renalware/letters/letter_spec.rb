# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Letter, type: :model do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:letterhead)
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:author)
        is_expected.to validate_presence_of(:main_recipient)
        is_expected.to validate_presence_of(:description)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to have_many(:electronic_receipts).dependent(:destroy)
        is_expected.to respond_to(:pathology_timestamp)
        is_expected.to respond_to(:pathology_snapshot)
      end

      describe "#include_pathology_in_letter_body?" do
        subject { described_class.new(letterhead: letterhead).include_pathology_in_letter_body? }

        let(:letterhead) do
          build_stubbed(:letter_letterhead, include_pathology_in_letter_body: true)
        end

        it { is_expected.to eq(true) }
      end

      describe "self.effective_date_sort" do
        it "generates a SQL coalesce statement to return the most relevant date for the letter" do
          expect(
            described_class.effective_date_sort
          ).to eq("coalesce(completed_at, approved_at, submitted_for_approval_at, created_at)")
        end
      end

      describe "#date" do
        context "when #approved_at is present" do
          it "returns #approved_at" do
            expect(
              described_class.new(
                created_at: "20-12-2020",
                approved_at: "21-12-2020"
              ).date
            ).to eq(Date.parse("21-12-2020"))
          end
        end

        context "when #approved_at is missing" do
          it "returns #submitted_for_approval_at" do
            expect(
              described_class.new(
                approved_at: nil,
                submitted_for_approval_at: "20-12-2020",
                created_at: "20-11-2020"
              ).date
            ).to eq(Date.parse("20-12-2020"))
          end
        end

        context "when #approved_at and submitted_for_approval_at are missing" do
          it "returns #created_at" do
            expect(
              described_class.new(
                approved_at: nil,
                submitted_for_approval_at: nil,
                created_at: "20-11-2020"
              ).date
            ).to eq(Date.parse("20-11-2020"))
          end
        end
      end
    end
  end
end
