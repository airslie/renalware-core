require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      before_filter :load_patient

      def show
        @donations = Donation.for_patient(@patient).reversed
        @donor_workup = DonorWorkup.for_patient(@patient).first_or_initialize
        @donor_operations = DonorOperation.for_patient(@patient).reversed
      end
    end
  end
end
