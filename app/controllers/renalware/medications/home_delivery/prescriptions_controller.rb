# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    module HomeDelivery
      class PrescriptionsController < BaseController
        include Pagy::Backend

        def index
          pagy, prescriptions = pagy(
            Medications::Delivery::PrescriptionsDueForDeliveryQuery.new(
              drug_type_code: params[:named_filter]
            ).call
          )
          authorize prescriptions
          render :index, locals: { prescriptions: prescriptions, pagy: pagy }
        end
      end
    end
  end
end
