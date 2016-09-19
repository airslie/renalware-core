require "rails_helper"

module Renalware
  module Patients
    describe WeightValidator, type: :validator do

      class Validatable
        include ActiveModel::Validations
        include Virtus::Model
        attribute :weight, Float
        validates :weight, "renalware/patients/weight" => true
      end

      describe "#validate" do
        before do
          yaml = <<-YAML
            activemodel:
              errors:
                models:
                  renalware/patients/validatable:
                    attributes:
                      weight:
                        out_of_range: "Out of range"
                        invalid_number : "Invalid number"
          YAML
          I18n.backend.store_translations(:en, YAML.load(yaml))
        end

        it "accepts whole numeric values" do
          model = Validatable.new
          model.weight = 120

          expect(model).to be_valid
        end

        it "accepts numeric values with one decimal place" do
          model = Validatable.new
          model.weight = 120.1

          expect(model).to be_valid
        end

        it "rejects valid weights that have more than one decimal place" do
          model = Validatable.new
          model.weight = 120.11

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.first[1]).to eq("Invalid number")
        end

        it "rejects invalid weights that have more than one decimal place" do
          model = Validatable.new
          model.weight = 1.11

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(2)
          messages = model.errors.messages[:weight]
          expect(messages).to include("Out of range")
          expect(messages).to include("Invalid number")
        end

        it "rejects non-numeric weights" do
          model = Validatable.new
          model.weight = "NaN"

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          messages = model.errors.messages[:weight]
          expect(messages).to include("Out of range")
        end

        it "rejects weights below the minimum" do
          model = Validatable.new
          model.weight = (Patients::WeightValidator::MIN_WEIGHT_KG - 1.0)

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.first[1]).to eq("Out of range")
        end

        it "rejects weights above the maximum" do
          model = Validatable.new
          model.weight = (Patients::WeightValidator::MAX_WEIGHT_KG + 1.0)

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.first[1]).to eq("Out of range")
        end
      end
    end
  end
end
