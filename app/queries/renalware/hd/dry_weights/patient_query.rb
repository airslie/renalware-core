module Renalware
  module HD
    module DryWeights
      class PatientQuery
        def initialize(patient:, filters_and_sorts: nil)
          @patient = patient
          @search_params = (filters_and_sorts || {}).reverse_merge!(s: "assessed_on desc")
        end

        def call
          search.result
        end

        def search
          @search ||= DryWeight.where(patient: @patient).search(@search_params)
        end
      end
    end
  end
end