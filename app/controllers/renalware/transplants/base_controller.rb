# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class BaseController < Renalware::BaseController
      def patient
        @transplant_patient ||= Renalware::Transplants.cast_patient(super)
      end

      # private

      def load_patient
        # noop
        # super
        # @patient = Renalware::Transplants.cast_patient(@patient)
      end
    end
  end
end
