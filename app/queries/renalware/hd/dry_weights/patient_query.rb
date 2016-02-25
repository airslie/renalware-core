module Renalware
  module HD
    module DryWeights
      class PatientQuery
        def initialize(patient:, q: nil)
          @patient = patient
          @q = (q || {}).reverse_merge!(s: "assessed_on desc")
        end

        def call
          search.result
        end

        def search
          @search ||= DryWeight.where(patient: @patient).search(@q)
        end
      end
    end
  end
end