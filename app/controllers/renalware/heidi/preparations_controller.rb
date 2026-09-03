module Renalware
  module Heidi
    class PreparationsController < BaseController
      include Renalware::Concerns::HeidiFeatureGate

      def show
        authorize Renalware::Clinics::ClinicVisit, :create?
      end
    end
  end
end
