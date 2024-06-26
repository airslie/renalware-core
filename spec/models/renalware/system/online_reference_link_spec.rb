# frozen_string_literal: true

describe Renalware::System::OnlineReferenceLink do
  let(:user) { create(:user) }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:url)
    is_expected.to validate_presence_of(:title)
  end

  describe "uniqueness" do
    subject { described_class.new(url: "X", title: "Y", created_by: user, updated_by: user) }

    it :aggregate_failures do
      is_expected.to validate_uniqueness_of(:url)
      is_expected.to validate_uniqueness_of(:title)
    end
  end

  describe "url format validation" do
    it :aggregate_failures do
      is_expected.to allow_value("https://abc123.com").for(:url)
      is_expected.to allow_value("http://abc123.com").for(:url)
      is_expected.not_to allow_value("xhttp://abc123.com").for(:url)
      is_expected.not_to allow_value("http:/abc123.com").for(:url)
      is_expected.not_to allow_value("http://").for(:url)
    end

    it "message" do
      expect(
        described_class.new(url: "xx").tap(&:valid?).errors[:url]&.first
      ).to eq("must start with http:// or https://")
    end
  end
end
