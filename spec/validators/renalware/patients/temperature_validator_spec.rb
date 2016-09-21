require "rails_helper"

module Renalware
  module Patients
    describe TemperatureValidator, type: :validator, focus: true do

      class Validatable
        include ActiveModel::Validations
        include Virtus::Model
        attribute :temperature, Float
        validates :temperature, "renalware/patients/temperature" => true
      end

      before do
        yaml = <<-YAML
          activemodel:
            errors:
              models:
                renalware/patients/validatable:
                  attributes:
                    temperature:
                      out_of_range: "Out of range"
                      invalid_number : "Invalid number"
        YAML
        I18n.backend.store_translations(:en, YAML.load(yaml))
      end

      it "accepts whole numeric values" do
        model = Validatable.new
        model.temperature = 32

        expect(model).to be_valid
      end

       it "accepts numeric values with one decimal place" do
          model = Validatable.new
          model.temperature = 32.1

          expect(model).to be_valid
       end

        it "rejects valid values that have more than one decimal place" do
          model = Validatable.new
          model.temperature = 32.11

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.messages[:temperature]).to include("Invalid number")
        end

        it "rejects non-numeric weights" do
          model = Validatable.new
          model.temperature = "NaN"

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.messages[:temperature]).to include("Out of range")
        end

        it "rejects weights below the minimum" do
          model = Validatable.new
          model.temperature = (Patients::TemperatureValidator::MIN_TEMP - 1.0)

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.messages[:temperature]).to include("Out of range")
        end

        it "rejects weights above the maximum" do
          model = Validatable.new
          model.temperature = (Patients::TemperatureValidator::MAX_TEMP + 1.0)

          expect(model).to_not be_valid
          expect(model.errors.count).to eq(1)
          expect(model.errors.messages[:temperature]).to include("Out of range")
        end
    end
  end
end
