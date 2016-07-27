require_dependency "renalware/medications"

module Renalware
  module Medications
    class TerminationsController < BaseController
      include PresenterHelper

      before_action :load_patient

      def create
        prescription = @patient.prescriptions.find(params[:prescription_id])
        @treatable = treatable_class.find(treatable_id)

        prescription.terminate(by: current_user).save!

        render_index
      end

      private

      def render_index
        render "renalware/medications/prescriptions/index", locals: {
          patient: @patient,
          treatable: present(@treatable, TreatablePresenter),
          current_search: current_prescriptions_query.search,
          current_prescriptions: present(current_prescriptions, PrescriptionPresenter),
          historical_prescriptions_search: historical_prescriptions_query.search,
          historical_prescriptions: present(historical_prescriptions, PrescriptionPresenter),
          drug_types: find_drug_types
        }
      end

      def current_prescriptions_query
        @current_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions.current,
            search_params: params[:q]
          )
      end

      def historical_prescriptions_query
        @historical_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions,
            search_params: params[:q]
          )
      end

      def current_prescriptions
        current_prescriptions_query.call.includes(:drug)
      end

      def historical_prescriptions
        historical_prescriptions_query.call.includes(:drug)
      end

      def find_drug_types
        Drugs::Type.all
      end

      def treatable_class
        @treatable_class ||= treatable_type.singularize.classify.constantize
      end

      def treatable_type
        params.fetch(:treatable_type)
      end

      def treatable_id
        params.fetch(:treatable_id)
      end
    end
  end
end
