# frozen_string_literal: true

module Renalware
  module Accesses
    class BaseController < Renalware::BaseController
      protected

      def patient
        @accesses_patient ||= Renalware::Accesses.cast_patient(super)
      end
    end
  end
end
