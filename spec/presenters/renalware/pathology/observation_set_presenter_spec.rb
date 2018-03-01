# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    describe ObservationSetPresenter do
      describe "method_missing" do
        describe "delegates .obx* calls to the underlying hash in order to create helper methods" do
          context "when there is an observation set with one hgb observation" do
            let(:hgb) { { "result" => "123.4", "observed_at" => "2017-12-12" } }
            let(:observation_hash) { { HGB: hgb } }
            let!(:observation_set) do
              CurrentObservationSet.new(values: ObservationsJsonbSerializer.load(observation_hash))
            end

            subject(:presenter) { described_class.new(observation_set) }

            it "returns the whole observation using set.<obx_code>" do
              expect(AllObservationCodes.instance).to receive(:all).once.times.and_return([:HGB])
              expect(presenter.hgb).to eq(hgb)
            end

            it "returns the observation result using set.<obx_code>_result" do
              expect(presenter.hgb_result).to eq(hgb["result"])
            end

            it "returns the observation date using set.<obx_code>observed_at" do
              expect(presenter.hgb_observed_at).to eq(Date.parse(hgb["observed_at"]))
            end
          end
        end
      end
    end
  end
end
