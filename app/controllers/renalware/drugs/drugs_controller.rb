require_dependency 'renalware/drugs'

module Renalware
  module Drugs
    class DrugsController < BaseController
      include Renalware::Concerns::Pageable

      before_filter :prepare_drugs_search, only: :index
      before_filter :prepare_paging, only: :index

      def selected_drugs
        @selected_drugs = Drug.for(params[:medication_switch])
        authorize @selected_drugs

        respond_to do |format|
          format.html
          format.json { render :json => @selected_drugs.as_json(:only => [:id, :name]) }
        end
      end

      def new
        @drug = Drug.new
        authorize @drug

        @drug_types = Type.all
      end

      def create
        @drug = Drug.new(drug_params)
        authorize @drug

        if @drug.save
          redirect_to drugs_drugs_path, notice: "You have successfully added a new drug."
        else
          render :new
        end
      end

      def index
        @drugs = @drugs_search.result(distinct: true)
        authorize @drugs

        @drugs = @drugs.page(@page).per(@per_page) if request.format.html?

        respond_to do |format|
          format.html
          format.json { render json: @drugs }
        end
      end

      def edit
        @drug = Drug.find(params[:id])
        authorize @drug

        @drug_types = Type.all
      end

      def update
        @drug = Drug.find(params[:id])
        authorize @drug

        if @drug.update(drug_params)
          redirect_to drugs_drugs_path, notice: "You have successfully updated a drug"
        else
          render :edit
        end
      end

      def destroy
        authorize Drug.destroy(params[:id])

        redirect_to drugs_drugs_path, notice: "You have successfully removed a drug."
      end

      private

      def drug_params
        params.require(:drugs_drug).permit(:name, :deleted_at, :drug_type_ids => [])
      end

      def prepare_drugs_search
        search_params = params.fetch(:q, {})
        @drugs_search = Drug.search(search_params)
        @drugs_search.sorts = 'name'
      end
    end
  end
end
