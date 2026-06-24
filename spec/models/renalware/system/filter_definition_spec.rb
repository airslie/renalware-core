module Renalware::System
  describe FilterDefinition do
    it "supports multi-select filters" do
      filter = described_class.new(code: :sex, type: :multi)

      expect(filter).to be_valid
      expect(filter.type).to eq("multi")
    end
  end
end
