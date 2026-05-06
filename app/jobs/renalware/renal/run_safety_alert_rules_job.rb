module Renalware
  module Renal
    class RunSafetyAlertRulesJob < ApplicationJob
      queue_as :default

      def perform
        SafetyAlerts::Runner.new.call
      end
    end
  end
end
