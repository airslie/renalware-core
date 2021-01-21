# frozen_string_literal: true

require_dependency "renalware/drugs"

module Renalware
  module Drugs
    class DrugsController < BaseController
      include Renalware::Concerns::Pageable
      skip_after_action :verify_policy_scoped

      before_action :prepare_drugs_search, only: :index
      after_action :track_action, except: :selected_drugs

      # Return a list of drugs as JSON for specific drug type (medication_switch)
      # TODO: Make a separate resource eg drug_/esa/drugs.json. E.g.
      # drug_type.drugs.ordered.pluck(:id, :name)
      def selected_drugs
        selected_drugs = Drug.for(params[:medication_switch])
                             .ordered
                             .pluck(:id, :name)
        authorize Renalware::Drugs::Drug, :selected_drugs?
        render json: selected_drugs
      end

      def new
        @drug = Drug.new
        authorize @drug
      end

      def create
        @drug = Drug.new(drug_params)
        authorize @drug

        if @drug.save
          redirect_to drugs_drugs_path,
                      notice: t(".success", model_name: "drug")
        else
          flash.now[:error] = t(".failed", model_name: "drug")
          render :new
        end
      end

      def index
        @drugs = @drugs_search.result(distinct: true)
        authorize @drugs

        @drugs = @drugs.page(page).per(per_page) if request.format.html?

        respond_to do |format|
          format.html
          format.json { render json: @drugs }
        end
      end

      def edit
        @drug = Drug.find(params[:id])
        authorize @drug
      end

      def update
        @drug = Drug.find(params[:id])
        authorize @drug
        if @drug.update(drug_params)
          redirect_to drugs_drugs_path, notice: t(".success", model_name: "drug")
        else
          flash.now[:error] = t(".failed", model_name: "drug")
          render :edit
        end
      end

      def destroy
        authorize Drug.destroy(params[:id])
        redirect_to drugs_drugs_path, notice: t(".success", model_name: "drug")
      end

      private

      def drug_params
        params.require(:drugs_drug).permit(
          :name, :deleted_at, drug_type_ids: []
        )
      end

      def prepare_drugs_search
        search_params = params.fetch(:q, {})
        @drugs_search = Drug.ransack(search_params)
        @drugs_search.sorts = "name"
      end
    end
  end
end
