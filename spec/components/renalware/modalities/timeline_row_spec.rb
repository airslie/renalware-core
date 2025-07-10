# frozen_string_literal: true

module Renalware
  RSpec.describe Modalities::TimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:modality, description: build(:modality_description, :pd)) }

    it "renders component" do
      expect(table_fragment.css(".toggler i")).to be_empty
      expect(table_fragment.text).to include("09-Jul-2025Modality ChangePD")
      expect(table_fragment.css(".hidden").text).to be_empty
    end
  end
end
