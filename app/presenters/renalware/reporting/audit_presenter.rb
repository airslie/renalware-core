require_dependency "renalware/reporting"
require "cronex"

module Renalware
  module Reporting
    class AuditPresenter < SimpleDelegator
      def refresh_schedule
        Cronex::ExpressionDescriptor.new(super).description
      end
    end
  end
end
