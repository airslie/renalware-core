# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class BaseController < Renalware::BaseController
      def patient
        @clinical_patient ||= Clinical.cast_patient(super)
      end

      def clinical_patient
        @clinical_patient ||= Clinical.cast_patient(patient)
      end
    end
  end
end
