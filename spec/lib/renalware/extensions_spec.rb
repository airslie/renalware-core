# frozen_string_literal: true

RSpec.describe Renalware::Extensions do
  around do |example|
    original_extensions = ENV.fetch("RENALWARE_EXTENSIONS", nil)

    example.run
  ensure
    if original_extensions.nil?
      ENV.delete("RENALWARE_EXTENSIONS")
    else
      ENV["RENALWARE_EXTENSIONS"] = original_extensions
    end
  end

  describe ".enabled" do
    it "returns normalized extension names" do
      ENV["RENALWARE_EXTENSIONS"] = " heroic, FOO ,heroic,, "

      expect(described_class.enabled).to eq(%w(heroic foo))
    end

    it "returns an empty array when no extensions are configured" do
      ENV.delete("RENALWARE_EXTENSIONS")
      allow(Dotenv).to receive(:load)

      expect(described_class.enabled).to eq([])
    end

    it "loads .env before reading configured extensions" do
      ENV.delete("RENALWARE_EXTENSIONS")
      allow(Dotenv).to receive(:load)

      described_class.enabled

      expect(Dotenv).to have_received(:load)
    end
  end

  describe ".enabled?" do
    it "matches configured extensions case-insensitively" do
      ENV["RENALWARE_EXTENSIONS"] = "HeRoIc"

      expect(described_class.enabled?(:heroic)).to be(true)
      expect(described_class.enabled?("HEROIC")).to be(true)
      expect(described_class.enabled?(:unknown)).to be(false)
    end
  end
end
