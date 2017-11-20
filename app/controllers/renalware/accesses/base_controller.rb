module Renalware
  module Accesses
    class BaseController < Renalware::BaseController
      protected

      def patient
        @accesses_patient ||= Renalware::Accesses.cast_patient(super)
      end

      private

      def load_patient
        super
        @patient = Renalware::Accesses.cast_patient(@patient)
      end
    end
  end
end
