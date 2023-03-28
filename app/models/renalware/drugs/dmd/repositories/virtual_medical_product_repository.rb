# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    module Repositories
      class VirtualMedicalProductRepository
        attr_reader :client

        VMP = "VMP"

        Entry = Struct.new(:name, :code, :form_code, :route_code,
                           :basis_of_strength,
                           :unit_of_measure_with_dose_code,
                           :strength_numerator_value,
                           :virtual_therapeutic_moiety_code,
                           :unit_of_measure_code,
                           :inactive,
                           keyword_init: true)

        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call(count: 2, offset: 0) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
          response = client.get(
            "production1/fhir/ValueSet/$expand", {
              url: "https://dmd.nhs.uk/ValueSet/VMP",
              property: %w(ROUTECD FORMCD UNIT_DOSE_UOMCD BASIS_STRNTCD
                           STRNT_NMRTR_UOMCD STRNT_NMRTR_VAL parent inactive),
              count:,
              offset:
            }
          )

          raise OntologyClient::RequestFailed unless response.success?

          return [] if response.body["expansion"]["total"] == 0

          response.body["expansion"]["contains"].filter_map do |row|
            next if row["extension"].blank?

            Entry.new(
              name: row["display"],
              code: row["code"],
              form_code: dig(row["extension"], "FORMCD"),
              route_code: dig(row["extension"], "ROUTECD"),
              unit_of_measure_with_dose_code: dig(row["extension"],
                                                  "UNIT_DOSE_UOMCD"),
              basis_of_strength: dig(row["extension"], "BASIS_STRNTCD"),
              strength_numerator_value: dig(row["extension"], "STRNT_NMRTR_VAL"),
              unit_of_measure_code: dig(row["extension"], "STRNT_NMRTR_UOMCD"),
              virtual_therapeutic_moiety_code: dig(row["extension"], "parent",
                                                   excluded_values: ["VMP"]),
              inactive: dig(row["extension"], "inactive")
            )
          end
        end

        private

        def dig(*args, **kwargs)
          ParseHelper.dig_property_out(*args, **kwargs)
        end

        # rubocop:disable Layout/LineLength

        # Example response
        # [
        #  {"extension"=>
        #   [{"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"FORMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"385194003"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"ROUTECD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"37161004"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"UNIT_DOSE_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"430293001"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>
        #       [{"url"=>"code", "valueCode"=>"VPI"},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"BASIS_STRNTCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk/BASIS_OF_STRNTH", "code"=>"1"}}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_VAL"}, {"url"=>"value", "valueDecimal"=>125.0}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"258684004"}}]}]}],
        #   "system"=>"https://dmd.nhs.uk",
        #   "code"=>"322278003",
        #   "display"=>"Paracetamol 125mg suppositories"},
        #
        # {"extension"=>
        #   [{"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"FORMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"385194003"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"ROUTECD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"37161004"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"UNIT_DOSE_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"430293001"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>
        #       [{"url"=>"code", "valueCode"=>"VPI"},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"BASIS_STRNTCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk/BASIS_OF_STRNTH", "code"=>"1"}}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_VAL"}, {"url"=>"value", "valueDecimal"=>500.0}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"258684004"}}]}]}],
        #   "system"=>"https://dmd.nhs.uk",
        #   "code"=>"322250004",
        #   "display"=>"Paracetamol 500mg suppositories"}
        # ]

        # rubocop:enable Layout/LineLength
      end
    end
  end
end
