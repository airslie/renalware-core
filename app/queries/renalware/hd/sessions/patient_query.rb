module Renalware
  module HD
    module Sessions
      class PatientQuery
        def initialize(patient:, q: nil)
          @patient = patient
          @q = q || { s: "performed_on desc" }
        end

        def call
          search.result
        end

        def search
          @search ||= QueryableSession.for_patient(@patient).search(@q)
        end

        private

        class QueryableSession < ActiveType::Record[Session]
          scope :for_patient, -> (patient) {
            where(patient: patient)
          }
        end
      end
    end
  end
end