module Renalware
  module Transplants
    class RecipientDashboardsController < BaseController
      before_filter :load_patient

      def show
        @registration = Registration.for_patient(@patient).first_or_initialize
        @recipient_operations = RecipientOperation.for_patient(@patient).ordered(:desc)
      end
    end
  end
end
