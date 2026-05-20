module Renalware
  module UKRDC
    describe PathologyObservationPresenter do
      describe "#pre_post" do
        it "returns nil when the observation description is not a pre/post HD sample" do
          observation = OpenStruct.new(description_hd_sample_type: nil)
          result = described_class.new(observation).pre_post

          expect(result).to be_nil
        end

        it "returns POST when the observation description is a post HD sample" do
          observation = OpenStruct.new(description_hd_sample_type: "post")
          result = described_class.new(observation).pre_post

          expect(result).to eq("POST")
        end

        it "returns PRE when the observation description is a pre HD sample" do
          observation = OpenStruct.new(description_hd_sample_type: "pre")
          result = described_class.new(observation).pre_post

          expect(result).to eq("PRE")
        end
      end

      describe "coding_standard" do
        context "when rr_coding_standard is :ukrr" do
          it "returns URRR" do
            observation = OpenStruct.new(description_rr_coding_standard: :ukrr)

            expect(described_class.new(observation).coding_standard).to eq("UKRR")
          end
        end

        context "when rr_coding_standard is :pv" do
          it "returns PV" do
            observation = OpenStruct.new(description_rr_coding_standard: :pv)

            expect(described_class.new(observation).coding_standard).to eq("PV")
          end
        end
      end

      describe "code" do
        context "when the obs has a loinc_code" do
          it "uses that" do
            observation = OpenStruct.new(
              description_loinc_code: "LOINC",
              description_code: "OTHER"
            )
            expect(described_class.new(observation).code).to eq("LOINC")
          end
        end

        context "when the obs has a '' loinc_code" do
          it "uses the normal code" do
            observation = OpenStruct.new(
              description_loinc_code: "",
              description_code: "OTHER"
            )
            expect(described_class.new(observation).code).to eq("OTHER")
          end
        end

        context "when the obs has a nil loinc_code" do
          it "uses the normal code" do
            observation = OpenStruct.new(
              description_loinc_code: nil,
              description_code: "OTHER"
            )
            expect(described_class.new(observation).code).to eq("OTHER")
          end
        end
      end

      describe "#interpretation_code" do
        it "maps possible lab values to UKRDC OBX:8 abbreviations" do
          {
            "Positive" => "POS",
            "positive" => "POS",
            " Negative " => "NEG",
            " bla " => "UNK",
            "indeterminate" => "UNK"

          }.each do |description, abbrev|
            observation = instance_double(Pathology::Observation, result: description)

            expect(described_class.new(observation).interpretation_code).to eq(abbrev)
          end
        end
      end
    end
  end
end
