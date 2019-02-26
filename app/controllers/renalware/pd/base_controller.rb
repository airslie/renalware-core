# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class BaseController < Renalware::BaseController
      protected

      def patient
        @pd_patient ||= Renalware::PD.cast_patient(super)
      end
    end
  end
end
