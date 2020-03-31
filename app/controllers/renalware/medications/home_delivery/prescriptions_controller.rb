# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    module HomeDelivery
      class PrescriptionsController < BaseController
        include Pagy::Backend
        skip_after_action :verify_policy_scoped

        # rubocop:disable Metrics/MethodLength
        def index
          form = SearchForm.new(search_params)
          query = Medications::Delivery::PrescriptionsDueForDeliveryQuery.new(
            drug_type_code: params[:named_filter],
            modality_description_id: form.modality_description_id,
            query: params[:q]
          )
          pagy, prescriptions = pagy(query.call)
          authorize prescriptions
          render :index, locals: {
            prescriptions: prescriptions,
            pagy: pagy,
            query: query.search,
            form: form
          }
        end
        # rubocop:enable Metrics/MethodLength

        class SearchForm
          include ActiveModel::Model
          include Virtus::Model

          attribute :modality_description_id, Integer
        end

        def search_params
          return {} unless params.key?(:search)

          params.require(:search).permit(:modality_description_id)
        end
      end
    end
  end
end
