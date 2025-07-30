# frozen_string_literal: true

RSpec.describe Shared::Icon do
  subject { described_class.new(name, size:) }

  let(:info_svg) do
    <<~SVG.strip
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="#{expected_classes}">
        <path stroke-linecap="round" stroke-linejoin="round" d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z"></path>
      </svg>
    SVG
  end

  let(:name) { :info }
  let(:size) { :xs }
  let(:expected_classes) { "h-3 w-3" }

  it "renders component" do
    expect(response).to eq(info_svg)
  end

  context "when size is not specified" do
    subject { described_class.new(name) }

    let(:expected_classes) { "h-5 w-5" }

    it "renders component" do
      expect(response).to eq(info_svg)
    end
  end
end
