require "rails_helper"

module Renalware
  module Pathology
    describe ObservationsJsonbSerializer do
      let(:hgb) { { "result" => "23.1", "observed_at" => "2017-12-12 01:01:01" } }

      describe "dynamic OBX methods via method missing" do
        it "allows retrieval of the observation hash via a method with the name of the OBX code" do
          expect(AllObservationCodes.instance).to receive(:all).exactly(2).times.and_return([:HGB])
          hash = ObservationsJsonbSerializer.load({ HGB: hgb })

          expect(hash.hgb).to eq(hgb)
          expect(hash.HGB).to eq(hgb)
        end

        it "allows accessing OBX result via the code" do
          expect(AllObservationCodes.instance).to receive(:all).once.and_return([:HGB])
          hash = ObservationsJsonbSerializer.load({ HGB: hgb })

          expect(hash.hgb_result).to eq(hgb["result"])
        end

        it "allows accessing OBX date via the code" do
          expect(AllObservationCodes.instance).to receive(:all).once.and_return([:HGB])
          hash = ObservationsJsonbSerializer.load({ HGB: hgb })

          expect(hash.hgb_observed_at).to eq(Date.parse(hgb["observed_at"]))
        end

        context "when the code does not exist" do
          it "raises method not defined" do
            hash = ObservationsJsonbSerializer.load({ HGB: hgb })

            expect{ hash.xyz }.to raise_error(NoMethodError)
            expect{ hash.xyz_result }.to raise_error(NoMethodError)
            expect{ hash.xyz_observed_at }.to raise_error(NoMethodError)
          end
        end

        context "when the hash is a string" do
          it "works as expcted" do
            expect(AllObservationCodes.instance).to receive(:all).once.and_return([:HGB])
            hash = ObservationsJsonbSerializer.load({ HGB: hgb }.to_json)

            expect(hash.hgb).to eq(hgb)
          end
        end
      end
    end
  end
end
