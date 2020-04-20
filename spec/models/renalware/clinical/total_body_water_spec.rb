# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Clinical
    describe TotalBodyWater, type: :model do
      describe "#calculate" do
        let(:patient) do
          Renalware::Clinics.cast_patient(create(:patient, sex: sex, born_on: 50.years.ago))
        end
        let(:sex) { "F" }

        def create_clinic_visit(weight: 100.99, height: 1.23)
          create(:clinic_visit, patient: patient, weight: weight, height: height)
        end

        context "when no recent weight measurement found" do
          it "returns 0" do
            create_clinic_visit(weight: nil)

            expect(described_class.new(patient: patient).calculate).to eq(0)
          end
        end

        context "when patient has no sex" do
          it "returns 0" do
            # NB having to skip validations here in order to null out sex.
            # The column definition allows nulls but the model does not.
            patient.update_column(:sex, nil)
            create_clinic_visit

            expect(described_class.new(patient: patient).calculate).to eq(0)
          end
        end

        context "when patient has a sex which is neither M or F" do
          let(:sex) { "NK" }

          it "returns 0" do
            create_clinic_visit

            expect(patient.sex.to_s).to eq("NK")
            expect(described_class.new(patient: patient).calculate).to eq(0)
          end
        end

        context "when height and weight are available in a recent clinic visit" do
          context "when male" do
            let(:sex) { "M" }

            it "returns the correct calculated TBW rounded to default 2 dp" do
              create_clinic_visit

              result = described_class.new(patient: patient).calculate

              # 2.447 - 0.09156 X age + 0.1074 X height (cm) + 0.3362 X weight (kg)
              # See https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
              # for a calculator
              expect(patient.sex.to_s).to eq("M")
              expect(result).to eq(45.03)
            end
          end

          context "when female" do
            let(:sex) { "F" }

            it "returns the correct calculated TBW rounded to default 2 dp" do
              create_clinic_visit

              result = described_class.new(patient: patient).calculate

              # -2.097 + 0.1069 X height (cm) + 0.2466 X weight (kg)
              # See https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
              # for a calculator
              expect(patient.sex.to_s).to eq("F")
              expect(result).to eq(35.96)
            end

            it "can get more decimal places if requested" do
              create_clinic_visit

              result = described_class.new(patient: patient).calculate(dp: 4)

              expect(result).to eq(35.9558)
            end
          end
        end
      end
    end
  end
end
