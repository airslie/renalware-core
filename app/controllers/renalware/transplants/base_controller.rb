# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class BaseController < Renalware::BaseController
      def patient
        Renalware::Transplants.cast_patient(super)
      end
    end
  end
end
