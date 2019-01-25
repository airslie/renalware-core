# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinics
    class BaseController < Renalware::BaseController
      # rubocop:disable Naming/MemoizedInstanceVariableName
      def patient
        @clinics_patient ||= Clinics.cast_patient(super)
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName
    end
  end
end
