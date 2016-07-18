require_dependency "renalware/hd"

module Renalware
  module HD
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = Renalware::HD.cast_patient(@patient)
      end
    end
  end
end
