require_dependency "renalware/low_clearance"

module Renalware
  module LowClearance
    class BaseController < Renalware::BaseController
      protected

      def patient
        LowClearance.cast_patient(super)
      end
    end
  end
end
