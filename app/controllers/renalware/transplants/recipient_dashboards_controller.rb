require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RecipientDashboardsController < BaseController
      before_filter :load_patient

      def show
        @recipient_workup = RecipientWorkup.for_patient(@patient).first_or_initialize
        @registration = Registration.for_patient(@patient).first_or_initialize
        @recipient_operations = RecipientOperation.for_patient(@patient).reversed
        @donations = Donation.for_recipient(@patient).reversed
      end
    end
  end
end
