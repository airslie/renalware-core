# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Snippets
    describe Snippet, type: :model do
      describe "validation" do
        it { is_expected.to belong_to(:author) }
        it { is_expected.to validate_presence_of(:title) }
        it { is_expected.to validate_presence_of(:body) }
        it { is_expected.to validate_presence_of(:author) }
        it { is_expected.to validate_presence_of(:times_used) }
        it { is_expected.to validate_numericality_of(:times_used) }
      end

      describe "uniqueness" do
        it "does not have a unique title across users" do
          create(:snippet, author: create(:snippets_user), title: "X")

          expect { create(:snippet, author: create(:snippets_user), title: "X") }.not_to raise_error
        end

        it "has a unique title within the scope of a user" do
          author = create(:snippets_user)
          create(:snippet, author: author, title: "X")

          expect {
            create(:snippet, author: author, title: "X")
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe "#record_uasge" do
        it "increments times_used by 1 and updates last_used_on" do
          snippet = create(:snippet, author: create(:snippets_user), title: "X")
          expect(snippet.times_used).to eq(0)

          expect {
            snippet.record_usage.reload
          }.to change { snippet.times_used }.by(1)
        end

        it "updates last_used_on to the current time" do
          travel_to Time.zone.now do
            snippet = create(:snippet, author: create(:snippets_user), title: "X")
            expect(snippet.last_used_on).to eq(nil)

            snippet.record_usage

            expect(snippet.last_used_on).to eq(Time.zone.now)
          end
        end
      end
    end
  end
end
