# frozen_string_literal: true

module Renalware
  module Legacy
    module Letters
      class Query
        attr_reader :patient, :q

        def initialize(patient:, q: nil)
          @q = q || {}
          @q[:s] ||= ["letter_date desc"]
          @patient = patient
        end

        def call
          search.result
        end

        def search
          @search ||= Renalware::Legacy::Letter
            .for_patient(patient)
            .includes(:authored_by, :legacy_letter_author)
            .ransack(q)
        end
      end
    end
  end
end
