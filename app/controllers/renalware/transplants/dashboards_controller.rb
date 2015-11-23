module Renalware
  module Transplants
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        @registration = Registration.for_patient(@patient).first_or_initialize
        @recipient_operations = RecipientOperation.for_patient(@patient).reversed
      end
    end
  end
end
