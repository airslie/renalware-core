require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = Pathology.cast_patient(@patient)
      end
    end
  end
end
