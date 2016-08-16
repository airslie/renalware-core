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

        def to_s
          case param_type
            when "ObservationResult" then
              "#{param_id_human_readable} #{param_comparison_operator} #{param_comparison_value}"
            when "PatientIsDiabetic" then
              if param_comparison_value == "true"
                "patient is DM"
              else
                "patient is not DM"
              end
            when "PatientSexIs" then
              "patient is #{param_comparison_value}"
            when "PrescriptionDrugCategory", "PrescriptionDrug","PrescriptionDrugType" then
              "prescribed drugs include #{param_id_human_readable}"
            when "RequestResult" then
              "last result is #{param_comparison_operator} #{param_comparison_value}"
            when "TransplantDateWithinWeeks" then
              "transplant date within #{param_comparison_value} weeks ago"
            when "TransplantRegistrationStatus" then
              "transplant registration status is #{param_comparison_value}"
            else
              "Unknown rule.param_type: #{param_type}"
          end
        end
      end
    end
  end
end
