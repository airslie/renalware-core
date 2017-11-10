require "rails_helper"

module Renalware
  module UKRDC
    describe PathologyObservationPresenter do
      describe "#pre_post" do
        it "returns NA is the patient is no on HD" do
          observation = OpenStruct.new(description_code: "UREP")
          result = described_class.new(observation).pre_post(patient_is_on_hd: false)
          expect(result).to eq("NA")
        end

        context "when patient is on HD" do
          it "returns POST for UREP observation code" do
            %w(UREP urep).each do |code|
              observation = OpenStruct.new(description_code: code)
              result = described_class.new(observation).pre_post(patient_is_on_hd: true)
              expect(result).to eq("POST")
            end
          end

          it "returns PRE for other observation codes" do
            %w(URR RBC WBC urepp UREPP).each do |code|
              observation = OpenStruct.new(description_code: code)
              result = described_class.new(observation).pre_post(patient_is_on_hd: true)
              expect(result).to eq("PRE")
            end
          end
        end
      end
    end
  end
end
