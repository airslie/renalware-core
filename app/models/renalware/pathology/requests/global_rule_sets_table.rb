require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRuleSetsTable
        attr_reader :clinics

        def initialize(request_descriptions, clinics, rule_sets)
          @request_descriptions = request_descriptions
          @clinics = clinics
          @rule_sets = rule_sets
        end

        def rows
          @request_descriptions.map do |request_description|
            OpenStruct.new(
              request_description: request_description,
              columns: find_columns(request_description)
            )
          end
        end

        def find_columns(request_description)
          @clinics.map do |clinic|
            OpenStruct.new(
              clinic: clinic,
              rule_sets: find_rule_sets(request_description, clinic)
            )
          end
        end

        def find_rule_sets(request_description, clinic)
          grouped_rule_sets.fetch([request_description.id, clinic.id], [])
        end

        def grouped_rule_sets
          @grouped_rule_sets ||= @rule_sets.group_by do |rule_set|
            [rule_set.request_description_id, rule_set.clinic_id]
          end
        end
      end
    end
  end
end
