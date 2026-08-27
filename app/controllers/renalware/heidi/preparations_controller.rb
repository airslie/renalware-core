module Renalware
  module Heidi
    class PreparationsController < BaseController
      def show
        authorize Renalware::Clinics::ClinicVisit, :create?
      end
    end
  end
end
