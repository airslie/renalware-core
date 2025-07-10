# frozen_string_literal: true

module Renalware
  RSpec.describe Clinics::TimelineRow do
    subject { described_class.new(sort_date:, record:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:record) { build(:clinic_visit) }
    let(:created_by) { record.created_by.full_name }
    let(:clinic) { record.clinic.name }

    it "renders component" do
      expect(table_fragment.css(".toggler i")).to be_empty
      expect(table_fragment.text).to include("09-Jul-2025Clinic Visit#{clinic}#{created_by}")
      expect(table_fragment.css(".hidden").text).to be_empty
    end
  end
end
