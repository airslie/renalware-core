module Renalware
  module Accesses
    class PlansController < Accesses::BaseController
      def new
        plan = Plan.new
        authorize plan
        render locals: { patient: patient, plan: plan }
      end

      private

    end
  end
end
