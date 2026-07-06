module Renalware
  describe BloodGroup do
    describe "#to_s" do
      it "displays the configured blood group name and rhesus" do
        create(:blood_group_description, code: "A1B", name: "A1B")

        blood_group = described_class.new(group: "A1B", rhesus: "positive")

        expect(blood_group.to_s).to eq("A1B Positive")
      end

      it "falls back to the stored code when there is no configured description" do
        blood_group = described_class.new(group: "A1A2")

        expect(blood_group.to_s).to eq("A1A2")
      end
    end
  end
end
