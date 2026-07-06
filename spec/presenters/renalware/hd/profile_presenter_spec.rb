describe Renalware::HD::ProfilePresenter do
  describe "#anticoagulant_type" do
    it "returns the configured anticoagulant name for the stored profile code" do
      create(:hd_anticoagulant, code: "heparin", name: "Heparin")
      profile = build(
        :hd_profile,
        document: {
          anticoagulant: {
            type: "heparin"
          }
        }
      )

      expect(described_class.new(profile).anticoagulant_type).to eq("Heparin")
    end

    it "falls back to the stored profile code when the anticoagulant has not been configured" do
      profile = build(
        :hd_profile,
        document: {
          anticoagulant: {
            type: "hospital_specific"
          }
        }
      )

      expect(described_class.new(profile).anticoagulant_type).to eq("hospital_specific")
    end
  end

  describe "#formatted_anuric" do
    it "returns Unknown when anuric is not set" do
      profile = build(:hd_profile, anuric: nil)

      expect(described_class.new(profile).formatted_anuric).to eq("Unknown")
    end

    it "returns Yes when anuric is true" do
      profile = build(:hd_profile, anuric: true)

      expect(described_class.new(profile).formatted_anuric).to eq("Yes")
    end

    it "returns No when anuric is false" do
      profile = build(:hd_profile, anuric: false)

      expect(described_class.new(profile).formatted_anuric).to eq("No")
    end
  end
end
