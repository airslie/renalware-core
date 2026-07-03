# frozen_string_literal: true

RSpec.describe Renalware::Legacy::Letters::SummaryPart do
  subject(:summary_part) { described_class.new(patient, user) }

  let(:patient) { create(:patient, :minimal, by: user) }
  let(:user) { create(:user) }

  describe "#render?" do
    around do |example|
      original = Renalware.config.legacy_letters_enabled
      example.run
    ensure
      Renalware.config.legacy_letters_enabled = original
    end

    it "is false when legacy letters are disabled even if the patient has legacy letters" do
      Renalware.config.legacy_letters_enabled = false
      create(:legacy_letter, patient:)

      expect(summary_part.render?).to be(false)
    end

    it "is false when legacy letters are enabled but the patient has no legacy letters" do
      Renalware.config.legacy_letters_enabled = true

      expect(summary_part.render?).to be(false)
    end

    it "is true when legacy letters are enabled and the patient has legacy letters" do
      Renalware.config.legacy_letters_enabled = true
      create(:legacy_letter, patient:)

      expect(summary_part.render?).to be(true)
    end
  end
end
