require "collection_presenter"
require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class DryWeightsController < Clinical::BaseController
      before_action :load_patient

      def index
        query = PatientDryWeightsQuery.new(patient: patient, search_params: params[:q])
        dry_weights = query.call.page(params[:page]).per(15)

        render locals: {
          search: query.search,
          dry_weights: CollectionPresenter.new(dry_weights, DryWeightPresenter),
          patient: patient
        }
      end

      def show
        dry_weight = DryWeight.for_patient(patient).find(params[:id])
        @dry_weight = DryWeightPresenter.new(dry_weight)
      end

      def new
        save_path_to_return_to
        dry_weight = DryWeight.new(
          patient: patient,
          assessor: current_user,
          assessed_on: Time.zone.today
        )
        render_new(dry_weight)
      end

      def create
        dry_weight = DryWeight.new(patient: patient)
        dry_weight.attributes = dry_weight_params

        if dry_weight.save
          redirect_to return_url, notice: t(".success", model_name: "dry weight")
          session.delete(:return_to)
        else
          flash[:error] = t(".failed", model_name: "dry weight")
          render_new(dry_weight)
        end
      end

      protected

      def save_path_to_return_to
        return unless request.format == :html
        session[:return_to] ||= request.referer
      end

      def return_url
        @return_url ||= begin
          path = session[:return_to]
          path = nil if path == new_patient_clinical_dry_weight_path(patient)
          path || patient_clinical_profile_path(patient)
        end
      end
      helper_method :return_url

      def render_new(dry_weight)
        render :new, locals: {
          dry_weight: dry_weight,
          patient: patient
        }
      end

      def dry_weight_params
        params
          .require(:clinical_dry_weight)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [:assessed_on, :weight, :assessor_id]
      end
    end
  end
end
