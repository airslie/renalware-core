require "collection_presenter"

module Renalware
  module HD
    class DryWeightsController < BaseController
      before_filter :load_patient

      def index
        @query = PatientDryWeightsQuery.new(patient: @patient, search_params: params[:q])
        dry_weights = @query.call.page(params[:page]).per(15)

        render locals: {
          search: @query.search,
          dry_weights: CollectionPresenter.new(dry_weights, DryWeightPresenter)
        }
      end

      def show
        dry_weight = DryWeight.for_patient(@patient).find(params[:id])
        @dry_weight = DryWeightPresenter.new(dry_weight)
      end

      def new
        @dry_weight = DryWeight.new(
          patient: @patient,
          assessor: current_user,
          assessed_on: Time.zone.today
        )
      end

      def create
        @dry_weight = DryWeight.new(patient: @patient)
        @dry_weight.attributes = dry_weight_params

        if @dry_weight.save
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "dry weight")
        else
          flash[:error] = t(".failed", model_name: "dry weight")
          render :new
        end
      end

      def edit
        @dry_weight = DryWeight.for_patient(@patient).find(params[:id])
      end

      def update
        @dry_weight = DryWeight.for_patient(@patient).find(params[:id])
        @dry_weight.attributes = dry_weight_params

        if @dry_weight.save
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "dry weight")
        else
          flash[:error] = t(".failed", model_name: "dry weight")
          render :edit
        end
      end

      protected

      def dry_weight_params
        params.require(:hd_dry_weight)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [:assessed_on, :weight, :assessor_id]
      end
    end
  end
end