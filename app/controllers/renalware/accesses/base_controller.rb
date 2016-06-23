module Renalware
  module Accesses
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = Renalware::Accesses.cast_patient(@patient)
      end
    end
  end
end
