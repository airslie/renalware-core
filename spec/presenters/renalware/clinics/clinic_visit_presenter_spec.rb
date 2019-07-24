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

    describe "#height" do
      it do
        visit = ClinicVisit.new(height: 1.2)
        presenter = described_class.new(visit)

        expect(presenter.height).to eq(1.2)
      end
    end

    describe "#height_in_cm" do
      subject { described_class.new(ClinicVisit.new(height: height)).height_in_cm }

      [
        [1.2, 120],
        [nil, nil],
        [0, 0],
        [2, 200]
      ].each do |height, expected_height_in_cm|
        context "when a height is #{height}" do
          let(:height) { height }

          it { is_expected.to eq(expected_height_in_cm) }
        end
      end
    end
  end
end
