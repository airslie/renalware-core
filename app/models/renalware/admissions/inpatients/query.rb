require_dependency "renalware/admissions"

module Renalware
  module Admissions
    module Inpatients
      class Query
        attr_reader :query

        def initialize(query = {})
          @query = query
        end

        def call
          search.result
        end

        def search
          @search ||= begin
            Inpatient
              .extending(Scopes)
              .includes(
                :hospital_unit,
                :hospital_ward,
                patient: { current_modality: [:description] }
              )
              .order(created_at: :desc)
              .ransack(query)
          end
        end

        module Scopes
          def ransackable_scopes(_auth_object = nil)
            %i(currently_admitted discharged_but_missing_a_summary)
          end
        end
      end
    end
  end
end
