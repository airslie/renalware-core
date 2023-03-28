# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Drugs::DMD
    describe Repositories::VirtualMedicalProductRepository do
      describe "#call" do
        let(:instance) {
          described_class.new(client: onthology_client)
        }

        let(:response_body) do
          {
            expansion: {
              contains: [
                { "extension" =>
                 [{ "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" => [{ "url" => "code", "valueCode" => "FORMCD" },
                                    { "url" => "value",
                                      "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                         "code" => "385194003" } }] },
                  { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" => [{ "url" => "code", "valueCode" => "ROUTECD" },
                                    { "url" => "value",
                                      "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                         "code" => "37161004" } }] },
                  { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" => [{ "url" => "code", "valueCode" => "UNIT_DOSE_UOMCD" },
                                    { "url" => "value",
                                      "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                         "code" => "430293001" } }] },
                  { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" => [{ "url" => "code", "valueCode" => "inactive" },
                                    { "url" => "value",
                                      "valueBoolean" => false }] },

                  { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" => [{ "url" => "code", "valueCode" => "parent" },
                                    { "url" => "value", "valueCode" => "VMP" }] },

                  { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" => [{ "url" => "code", "valueCode" => "parent" },
                                    { "url" => "value", "valueCode" => "90332006" }] },

                  { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                    "extension" =>
                     [{ "url" => "code", "valueCode" => "VPI" },
                      { "url" => "subproperty",
                        "extension" => [{ "url" => "code", "valueCode" => "BASIS_STRNTCD" },
                                        { "url" => "value",
                                          "valueCoding" => {
                                            "system" => "https://dmd.nhs.uk/BASIS_OF_STRNTH",
                                            "code" => "1"
                                          } }] },
                      { "url" => "subproperty",
                        "extension" => [{ "url" => "code", "valueCode" => "STRNT_NMRTR_VAL" },
                                        { "url" => "value", "valueDecimal" => 125.0 }] },
                      { "url" => "subproperty",
                        "extension" => [{ "url" => "code", "valueCode" => "STRNT_NMRTR_UOMCD" },
                                        { "url" => "value",
                                          "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                             "code" => "258684004" } }] }] }],
                  "system" => "https://dmd.nhs.uk",
                  "code" => "322278003",
                  "display" => "Paracetamol 125mg suppositories" },

                { "extension" =>
                  [{ "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                     "extension" => [{ "url" => "code", "valueCode" => "FORMCD" },
                                     { "url" => "value",
                                       "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                          "code" => "385194003" } }] },
                   { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                     "extension" => [{ "url" => "code", "valueCode" => "ROUTECD" },
                                     { "url" => "value",
                                       "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                          "code" => "37161004" } }] },
                   { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                     "extension" => [{ "url" => "code", "valueCode" => "UNIT_DOSE_UOMCD" },
                                     { "url" => "value",
                                       "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                          "code" => "430293001" } }] },
                   { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                     "extension" => [{ "url" => "code", "valueCode" => "inactive" },
                                     { "url" => "value",
                                       "valueBoolean" => true }] },
                   { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
                     "extension" =>
                     [{ "url" => "code", "valueCode" => "VPI" },
                      { "url" => "subproperty",
                        "extension" => [{ "url" => "code", "valueCode" => "BASIS_STRNTCD" },
                                        { "url" => "value",
                                          "valueCoding" => {
                                            "system" => "https://dmd.nhs.uk/BASIS_OF_STRNTH",
                                            "code" => "1"
                                          } }] },
                      { "url" => "subproperty",
                        "extension" => [{ "url" => "code", "valueCode" => "STRNT_NMRTR_VAL" },
                                        { "url" => "value", "valueDecimal" => 500.0 }] },
                      { "url" => "subproperty",
                        "extension" => [{ "url" => "code", "valueCode" => "STRNT_NMRTR_UOMCD" },
                                        { "url" => "value",
                                          "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                             "code" => "258684004" } }] }] }],
                  "system" => "https://dmd.nhs.uk",
                  "code" => "322250004",
                  "display" => "Paracetamol 500mg suppositories" }
              ]
            }
          }.deep_stringify_keys
        end

        let(:stubs) { Faraday::Adapter::Test::Stubs.new }
        let(:onthology_client) {
          class_double \
            OntologyClient,
            call: Faraday.new { |b| b.adapter(:test, stubs) }
        }

        before do
          stubs.get("/production1/fhir/ValueSet/$expand") do |_env|
            [
              200,
              { "Content-Type": "application/javascript" },
              response_body
            ]
          end
        end

        it "returns friendly data" do
          result = instance.call

          expect(result.size).to eq 2

          vmp1 = result.first

          expect(vmp1).to have_attributes \
            code: "322278003",
            name: "Paracetamol 125mg suppositories",
            form_code: "385194003",
            route_code: "37161004",
            unit_of_measure_with_dose_code: "430293001",
            basis_of_strength: "1",
            strength_numerator_value: 125.0,
            unit_of_measure_code: "258684004",
            virtual_therapeutic_moiety_code: "90332006",
            inactive: false

          vmp2 = result.second
          expect(vmp2).to have_attributes \
            code: "322250004",
            name: "Paracetamol 500mg suppositories",
            form_code: "385194003",
            route_code: "37161004",
            unit_of_measure_with_dose_code: "430293001",
            basis_of_strength: "1",
            strength_numerator_value: 500.0,
            unit_of_measure_code: "258684004",
            virtual_therapeutic_moiety_code: nil,
            inactive: true
        end
      end
    end
  end
end
