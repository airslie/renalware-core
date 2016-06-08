require_dependency "renalware/renal"

module Renalware
  module Renal
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = Renal.cast_patient(@patient)
      end
    end
  end
end
