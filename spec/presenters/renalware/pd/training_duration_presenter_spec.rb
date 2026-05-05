module Renalware
  module PD
    describe TrainingDurationPresenter do
      describe ".dropdown_options" do
        it "uses human day labels with ISO8601 values" do
          expect(described_class.dropdown_options).to include(["4 days", "P4D"])
        end
      end

      describe "#to_s" do
        it "formats an ISO8601 duration as days" do
          expect(described_class.new("P4D").to_s).to eq("4 days")
        end
      end
    end
  end
end
