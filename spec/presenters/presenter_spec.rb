describe Presenter do
  describe ".for" do
    it "renders a generic modality description as its name" do
      description = Renalware::Modalities::Description.new(name: "Transfer Out")

      expect(described_class.for(description)).to eq("Transfer Out")
    end
  end
end
