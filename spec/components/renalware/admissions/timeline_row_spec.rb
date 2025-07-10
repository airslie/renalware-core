# frozen_string_literal: true

module Renalware
  RSpec.describe Admissions::TimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:admissions_admission) }

    it "renders component" do
      expect(table_fragment.css(".toggler i")).not_to be_empty
      expect(table_fragment.text).to include "09-Jul-2025AdmissionUnknown"
      expect(table_fragment.css(".hidden").text).to include "Ward A"
    end
  end
end
