module Renalware::System
  describe FilterDefinition do
    it "supports multi-select filters" do
      filter = described_class.new(code: :sex, type: :multi)

      expect(filter).to be_valid
      expect(filter.type).to eq("multi")
    end

    describe "#collection?" do
      it "returns true for filters backed by distinct column values" do
        expect(described_class.new(code: :sex, type: :list)).to be_collection
        expect(described_class.new(code: :sex, type: :multi)).to be_collection
        expect(described_class.new(code: :sex, type: :search)).not_to be_collection
      end
    end

    describe "#ransack_attribute" do
      it "returns the Ransack attribute for each filter type" do
        expect(described_class.new(code: :sex, type: :list).ransack_attribute).to eq("sex_eq")
        expect(described_class.new(code: :sex, type: :multi).ransack_attribute).to eq("sex_in")
        expect(described_class.new(code: :sex, type: :search).ransack_attribute).to eq("sex_cont")
      end
    end
  end
end
