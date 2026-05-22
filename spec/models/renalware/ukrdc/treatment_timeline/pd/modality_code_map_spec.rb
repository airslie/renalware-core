module Renalware
  module UKRDC
    describe TreatmentTimeline::PD::ModalityCodeMap do
      subject(:code_map) { described_class.new }

      let!(:apd_ukrdc_modality_code) { create(:ukrdc_modality_code, :apd) }
      let!(:capd_ukrdc_modality_code) { create(:ukrdc_modality_code, :capd) }

      describe "#code_for_pd_regime" do
        it "defaults to APD when there is no regime" do
          expect(code_map.code_for_pd_regime(nil)).to eq(apd_ukrdc_modality_code)
        end

        it "maps APD regimes to APD" do
          expect(code_map.code_for_pd_regime(build(:apd_regime))).to eq(apd_ukrdc_modality_code)
        end

        it "maps CAPD regimes to CAPD" do
          expect(code_map.code_for_pd_regime(build(:capd_regime))).to eq(capd_ukrdc_modality_code)
        end

        it "maps assisted APD regimes to APD" do
          expect(code_map.code_for_pd_regime(build(:apd_assisted_regime))).to(
            eq(apd_ukrdc_modality_code)
          )
        end

        it "maps assisted CAPD regimes to CAPD" do
          expect(code_map.code_for_pd_regime(build(:capd_assisted_regime))).to(
            eq(capd_ukrdc_modality_code)
          )
        end
      end
    end
  end
end
