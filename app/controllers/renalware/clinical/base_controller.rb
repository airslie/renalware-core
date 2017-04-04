require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class BaseController < Renalware::BaseController
      def patient
        @clinical_patient ||= Clinical.cast_patient(super)
      end
    end
  end
end
