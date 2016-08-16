require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RulesController < Pathology::BaseController
        def index
          authorize rule_sets
          presented_rule_sets = GlobalRuleSetPresenter.present(rule_sets)
          rules_table = RequestAlgorithmRulesTable.new(request_descriptions, clinics, presented_rule_sets)

          render :index, locals: {
            rules_table: rules_table
          }
        end

        def rule_sets
          @rule_sets ||= GlobalRuleSet.all
        end

        def clinics
          Renalware::Clinics::OrderedClinicQuery.new(clinic_ids).call
        end

        # NOTE: These are the clinics listed in the order they are in the Barts
        #       Pathology algorithm document
        def clinic_ids
          [10, 4, 11, 15, 9, 8]
        end

        def request_descriptions
          Renalware::Pathology::OrderedRequestDescriptionQuery.new(request_description_ids).call
        end

        # NOTE: These are the request_descriptions listed in the order they are in the Barts
        #       Pathology algorithm document
        def request_description_ids
          [10, 9, 11, 144, 152, 38, 5, 154, 176, 50, 58, 17, 92, 48, 30, 177, 89, 13, 116, 67, 178,
            52, 21, 20, 179, 139, 180, 181, 71, 81, 1, 25, 6, 7, 18, 182, 155, 183, 170, 184, 185,
            186, 187, 188, 189, 190, 191, 192, 189, 193, 194, 195]
        end
      end

      class RequestAlgorithmRulesTable
        attr_reader :clinics

        def initialize(request_descriptions, clinics, rule_sets)
          @request_descriptions = request_descriptions
          @clinics = clinics
          @grouped_rule_sets =
            rule_sets.group_by { |rule_set| [rule_set.request_description_id, rule_set.clinic_id] }
        end

        def rows
          @request_descriptions.map do |request_description|
            OpenStruct.new(
              request_description: request_description,
              columns: columns(request_description)
            )
          end
        end

        def columns(request_description)
          @clinics.map do |clinic|
            OpenStruct.new(
              clinic: clinic,
              rule_sets: find_rule_sets(request_description, clinic)
            )
          end
        end

        def find_rule_sets(request_description, clinic)
          @grouped_rule_sets.fetch([request_description.id, clinic.id], [])
        end
      end
    end
  end
end
