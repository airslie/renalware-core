module Renalware
  module Transplants
    describe RegistrationNHSBTStatusDescription do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:code)
        is_expected.to validate_presence_of(:name)
      end

      describe "#to_s" do
        it "returns the name" do
          description = described_class.new(name: "Active")

          expect(description.to_s).to eq("Active")
        end
      end
    end
  end
end
