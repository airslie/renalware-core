require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRulePresenter < SimpleDelegator
        def self.present(rules)
          rules.map { |rule| new rule }
        end

        def param_id_human_readable
          case param_type
            when "ObservationResult" then
              Renalware::Pathology::ObservationDescription.find(param_id).code
            when "RequestResult" then
              Renalware::Pathology::RequestDescription.find(param_id).code
            when "PrescriptionDrug" then
              Renalware::Drugs::Drug.find(param_id).name
            when "PrescriptionDrugType" then
              Renalware::Drugs::Type.find(param_id).code
            when "PrescriptionDrugCategory" then
              Renalware::Pathology::Requests::DrugCategory.find(param_id).name
            else
              param_id
          end
        end

        def param
          param_type_class =
            "::Renalware::Pathology::Requests::ParamType::#{param_type}"
            .constantize

          param_type_class
            .new(
              nil,
              param_id,
              param_comparison_operator,
              param_comparison_value
            )
        end

        def to_s
          "if #{param} then #{global_rule_set.frequency}"
        end
      end
    end
  end
end
