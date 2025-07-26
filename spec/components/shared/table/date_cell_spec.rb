# frozen_string_literal: true

RSpec.describe Shared::DateCell do
  subject { described_class.new(date_like) }

  let(:date_like) { Date.new(2025, 7, 24) }

  it "renders component" do
    expect(fragment.text).to include("24-Jul-2025")
  end

  context "when a datetime" do
    let(:date_like) { DateTime.new(2025, 7, 24, 12, 0, 0) }

    it "does not include the time" do
      expect(fragment.text).not_to include("12:00")
    end
  end
end
