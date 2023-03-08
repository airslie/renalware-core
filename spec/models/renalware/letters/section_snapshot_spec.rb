# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Letters::SectionSnapshot do
    let(:user) { create(:user) }
    let(:letter) {
      create(:draft_letter,
             topic: topic,
             patient: build(:letter_patient),
             main_recipient: build(:letter_recipient, :main),
             by: user)
    }

    let(:topic) { create(:letter_topic, section_identifiers: [:hd_section]) }

    describe ".create_all" do
      context "when a snapshot doesn't exists" do
        it "creates it" do
          described_class.create_all(letter)

          expect(letter.section_snapshots.count).to eq 1

          snapshot = letter.section_snapshots.first
          expect(snapshot.section_identifier).to eq "hd_section"
          expect(snapshot.content).to include "<dl></dl>"
        end
      end

      context "when a snapshot already exists" do
        let!(:section_snapshot) {
          create(:section_snapshot, letter: letter, content: "test",
                                    section_identifier: "hd_section")
        }

        it "skips over it" do
          expect(letter.section_snapshots.count).to eq 1

          described_class.create_all(letter)

          expect(letter.section_snapshots.count).to eq 1

          snapshot = letter.section_snapshots.first
          expect(snapshot.section_identifier).to eq "hd_section"
          expect(snapshot.content).to eq "test"
        end
      end
    end

    describe ".update_or_create_one" do
      context "when a snapshot doesn't exists" do
        it "creates it" do
          described_class.update_or_create_one(letter, "hd_section")

          expect(letter.section_snapshots.count).to eq 1

          snapshot = letter.section_snapshots.first
          expect(snapshot.section_identifier).to eq "hd_section"
          expect(snapshot.content).to include "<dl></dl>"
        end
      end

      context "when a snapshot already exists" do
        let!(:section_snapshot) {
          create(:section_snapshot, letter: letter, content: "test",
                                    section_identifier: "hd_section")
        }

        it "updates it" do
          expect(letter.section_snapshots.count).to eq 1

          described_class.update_or_create_one(letter, "hd_section")

          expect(letter.section_snapshots.count).to eq 1

          snapshot = letter.section_snapshots.first
          expect(snapshot.section_identifier).to eq "hd_section"
          expect(snapshot.content).to include "<dl></dl>"
        end
      end
    end
  end
end
