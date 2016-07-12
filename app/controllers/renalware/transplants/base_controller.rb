require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = Renalware::Transplants.cast_patient(@patient)
      end
    end
  end
end
