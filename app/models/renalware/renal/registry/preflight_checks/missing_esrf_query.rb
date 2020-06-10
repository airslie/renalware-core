# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    module Registry
      module PreflightChecks
        class MissingESRFQuery
          include ModalityScopes

          attr_reader :relation, :query_params

          def initialize(relation: nil, query_params: {})
            @relation = relation || default_relation
            @query_params = query_params
            @query_params[:s] = "modality_descriptions_name ASC" if @query_params[:s].blank?
          end

          def default_relation
            Renalware::Renal::Patient.left_outer_joins(:profile)
          end

          def call
            search
              .result
              .extending(ModalityScopes)
              .preload(current_modality: [:description])
          end

          def search
            @search ||= relation.ransack(query_params)
          end

          def self.missing_data_for(_patient)
            [
              :esrf
            ]
          end
        end
      end
    end
  end
end
