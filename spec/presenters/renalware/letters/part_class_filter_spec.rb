# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe PartClassFilter do
      describe "#to_h" do
        subject(:filter) { instance.filter }

        let(:sections) { [Part::RecentPathologyResults, Part::Problems] }
        let(:instance) do
          described_class.new(
            sections: sections,
            include_pathology_in_letter_body: include_pathology_in_letter_body
          )
        end

        context "when include_pathology_in_letter_body is true" do
          let(:include_pathology_in_letter_body) { true }

          it { is_expected.to eq([Part::RecentPathologyResults, Part::Problems]) }
        end

        context "when include_pathology_in_letter_body is false" do
          let(:include_pathology_in_letter_body) { false }

          it { is_expected.to eq([Part::Problems]) }
        end
      end
    end
  end
end
