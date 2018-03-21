# frozen_string_literal: true

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
          @search ||= Session.where(patient: @patient).search(@q)
        end
      end
    end
  end
end
