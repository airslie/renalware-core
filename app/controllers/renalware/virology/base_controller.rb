# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Virology
    class BaseController < Renalware::BaseController
      protected

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def patient
        @virology_patient ||= Renalware::Virology.cast_patient(super)
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName
    end
  end
end
