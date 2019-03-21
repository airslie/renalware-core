# frozen_string_literal: true

require "rails_helper"

module Renalware::Clinics
  describe ClinicVisitPresenter do
    describe "#sanitized_notes" do
      it "removes blackisted tags but leaves whitelisted tags" do
        BLACKLIST = %w(b h1 i pre blockquote).freeze
        WHITELIST = %w(p ul ol li span div).freeze

        html = BLACKLIST.map { |tag| "<#{tag}>#{tag.upcase}</#{tag}>" }
        html.append WHITELIST.map { |tag| "<#{tag}>#{tag.upcase}</#{tag}>" }
        html.append "<br>"

        visit = ClinicVisit.new(notes: html.join(" "))
        presenter = described_class.new(visit)

        expected_html = BLACKLIST.map(&:upcase)
        expected_html.append WHITELIST.map { |tag| "<#{tag}>#{tag.upcase}</#{tag}>" }
        expected_html.append "<br>"

        expect(presenter.sanitized_notes).to eq(expected_html.join(" "))
      end
    end
  end
end
