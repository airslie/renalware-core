# frozen_string_literal: true

module Renalware
  RSpec.describe Letters::TimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:draft_letter) }

    it "renders component" do
      expect(table_fragment.css(".toggler i")).not_to be_empty
      expect(table_fragment.text).to include("09-Jul-2025Letter (Draft)")
      expect(table_fragment.css(".hidden").text).to include(
        "I am pleased to report a marked improvement in her condition."
      )
    end
  end
end
