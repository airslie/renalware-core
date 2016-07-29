require "rails_helper"

describe Renalware::Pathology::Requests::SampleDescription do
  let(:sample_type) { "red cap" }
  let(:sample_number_bottles) { 2 }

  let(:sample_description) do
    Renalware::Pathology::Requests::SampleDescription.new(sample_type, sample_number_bottles).to_s
  end

  context "both sample_type and sample_number_bottles are present" do
    it { expect(sample_description).to include("#{sample_type}", "#{sample_number_bottles} bottles") }
  end

  context "only sample_type is present" do
    let(:sample_number_bottles) { nil }

    it { expect(sample_description).to include("#{sample_type}") }
  end

  context "only sample_number_bottles is present" do
    context "sample_number_bottles > 1" do
      let(:sample_type) { nil }
      let(:sample_number_bottles) { 3 }

      it { expect(sample_description).to include("#{sample_number_bottles} bottles") }
    end

    context "sample_number_bottles = 1" do
      let(:sample_type) { nil }
      let(:sample_number_bottles) { 1 }

      it { expect(sample_description).to include("#{sample_number_bottles} bottle") }
    end
  end
end
