module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      before_filter :load_patient

      def show
        @donations = Donation.for_patient(@patient).ordered(:desc)
        @donor_workup = DonorWorkup.for_patient(@patient).first_or_initialize
        @donor_operations = DonorOperation.for_patient(@patient).ordered(:desc)
      end
    end
  end
end
