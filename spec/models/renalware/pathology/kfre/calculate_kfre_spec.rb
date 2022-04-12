# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    module KFRE
      describe CalculateKFRE do
        subject(:svc) do
          described_class.new(
            sex: sex,
            age: age,
            acr: acr,
            egfr: egfr
          )
        end

        let(:sex) { "F" }
        let(:age) { 21 }
        let(:acr) { "300" }
        let(:egfr) { "10" }

        context "when sex is nil" do
          let(:sex) { nil }

          it "returns silently" do
            expect(svc.call).to be_nil
          end
        end

        context "when age is nil" do
          let(:age) { nil }

          it "returns silently" do
            expect(svc.call).to be_nil
          end
        end

        context "when acr_value is nil or 0" do
          [0, nil].each do |val|
            let(:acr) { val }

            it "returns silently" do
              expect(svc.call).to be_nil
            end
          end
        end

        context "when egfr is nil or 0" do
          [0, nil].each do |val|
            let(:egfr) { val }

            it "returns silently" do
              expect(svc.call).to be_nil
            end
          end
        end

        describe "male 80y" do
          let(:sex) { "F" }
          let(:age) { 80 }
          let(:acr) { 40.1 }
          let(:egfr) { "10.2" }

          it do
            expect(svc.call).to have_attributes(
              yr2: 19.4,
              yr5: 53.8
            )
          end
        end

        describe "female 80y" do
          let(:sex) { "M" }
          let(:age) { 80 }
          let(:acr) { 40.1 }
          let(:egfr) { 10.2 }

          it do
            expect(svc.call).to have_attributes(
              yr2: 24.1,
              yr5: 62.7
            )
          end
        end

        describe "male 50y" do
          let(:sex) { "M" }
          let(:age) { 50 }
          let(:acr) { "30.5" }
          let(:egfr) { "30.5" }

          it do
            expect(svc.call).to have_attributes(
              yr2: 4.8,
              yr5: 16.2
            )
          end
        end

        describe "female 50y" do
          let(:sex) { "F" }
          let(:age) { 50 }
          let(:acr) { 30.9 }
          let(:egfr) { 30.9 }

          it do
            expect(svc.call).to have_attributes(
              yr2: 3.6,
              yr5: 12.4
            )
          end
        end
      end
    end
  end
end
