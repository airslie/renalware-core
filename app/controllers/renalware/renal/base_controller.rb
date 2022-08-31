# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class BaseController < Renalware::BaseController

      def patient
        Renal.cast_patient(super)
      end
    end
  end
end
