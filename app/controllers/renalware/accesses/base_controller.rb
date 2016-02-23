module Renalware
  module Accesses
    class BaseController < Renalware::BaseController

      private

      def load_patient
        super
        @patient = ActiveType.cast(@patient, Renalware::Accesses::Patient)
      end
    end
  end
end
