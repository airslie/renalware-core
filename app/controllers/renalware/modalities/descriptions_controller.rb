require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class DescriptionsController < BaseController

      before_action :load_modality_description, only: [:edit, :update]

      def new
        @modality_description = Description.new
        authorize @modality_description
      end

      def create
        @modality_description = Description.new(modality_description_params)
        authorize @modality_description

        if @modality_description.save
          redirect_to modalities_descriptions_path,
            notice: t(".success", model_name: "modality description")
        else
          flash[:error] = t(".failed", model_name: "modality description")
          render :new
        end
      end

      def index
        @modalilty_descriptions = Description.all
        authorize @modalilty_descriptions
      end

      def update
        if @modality_description.update(modality_description_params)
          redirect_to modalities_descriptions_path,
            notice: t(".success", model_name: "modality description")
        else
          flash[:error] = t(".failed", model_name: "modality description")
          render :edit
        end
      end

      def destroy
        authorize Description.destroy(params[:id])
        redirect_to modalities_descriptions_path,
          notice: t(".success", model_name: "modality description")
      end

      private

      def modality_description_params
        params.require(:modalities_description).permit(:name, :code, :site)
      end

      def load_modality_description
        @modality_description = Description.find(params[:id])
        authorize @modality_description
      end
    end
  end
end
