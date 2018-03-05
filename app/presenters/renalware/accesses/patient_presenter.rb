# frozen_string_literal: true

require "renalware"
require "renalware/accesses"

module Renalware
  module Accesses
    class PatientPresenter < SimpleDelegator
      # delegate_missing_to :patient # TODO: when rails 5.1, try instead of SimpleDelegator
      delegate :plan_type, :created_at, to: :access_plan, prefix: true
      delegate :type, :started_on, to: :access_profile, prefix: true

      def initialize(patient)
        super(Accesses.cast_patient(patient.__getobj__))
      end

      private

      def access_plan
        @access_plan ||= current_plan || NullObject.instance
      end

      def access_profile
        @access_profile ||= current_profile || NullObject.instance
      end
    end
  end
end
