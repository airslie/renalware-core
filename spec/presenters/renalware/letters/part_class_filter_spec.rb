# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe PartClassFilter do
      describe "#to_h" do
        let(:part_classes) { { recent_pathology_results: :foo, problems: :bar } }
        let(:filter) do
          described_class.new(
            part_classes: part_classes,
            include_pathology_in_letter_body: include_pathology_in_letter_body
          )
        end

        subject(:to_h) { filter.to_h.keys }

        context "when include_pathology_in_letter_body is true" do
          let(:include_pathology_in_letter_body) { true }

          it { is_expected.to eq([:recent_pathology_results, :problems]) }
        end

        context "when include_pathology_in_letter_body is false" do
          let(:include_pathology_in_letter_body) { false }

          it { is_expected.to eq([:problems]) }
        end
      end
    end
  end
end
