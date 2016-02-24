module Renalware
  module HD
    module DryWeights
      class PatientQuery
        def initialize(patient:, q: nil)
          @patient = patient
          @q = q || { s: "assessed_on desc" }
        end

        def call
          search.result
        end

        def search
          @search ||= QueryableDryWeight.for_patient(@patient).search(@q)
        end

        private

        class QueryableDryWeight < ActiveType::Record[DryWeight]
          scope :for_patient, -> (patient) {
            where(patient: patient)
          }
        end
      end
    end
  end
end