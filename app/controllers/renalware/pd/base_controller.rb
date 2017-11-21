require_dependency "renalware/pd"

module Renalware
  module PD
    class BaseController < Renalware::BaseController
      protected

      def patient
        @pd_patient ||= Renalware::PD.cast_patient(super)
      end

      private

      def load_patient
        super
        @patient = Renalware::PD.cast_patient(patient)
      end
    end
  end
end
