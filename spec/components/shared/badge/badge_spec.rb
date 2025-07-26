# frozen_string_literal: true

RSpec.describe Shared::Badge do
  subject { described_class.new(value, colors:) }

  let(:value) { "medium" }
  let(:colors) { { value => color } }
  let(:color) { "bg-yellow-100" }

  it "renders component" do
    expect(fragment.css("div.bg-yellow-100").text).to eq(value)
  end

  context "when color is dark" do
    let(:color) { "bg-yellow-600" }

    it "renders component with white text" do
      expect(fragment.css("div.text-white")).to be_present
    end
  end
end
