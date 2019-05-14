# frozen_string_literal: true

require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class DescriptionsController < BaseController
      def new
        modality_description = Description.new
        authorize modality_description
        render_new(modality_description)
      end

      def create
        modality_description = Description.new(modality_description_params)
        authorize modality_description

        if modality_description.save
          redirect_to modalities_descriptions_path,
                      notice: t(".success", model_name: "modality description")
        else
          flash.now[:error] = t(".failed", model_name: "modality description")
          render_new(modality_description)
        end
      end

      def index
        modality_descriptions = Description.all
        authorize modality_descriptions
        render locals: { modality_descriptions: modality_descriptions }
      end

      def edit
        render_edit(find_and_authorize_modality_description)
      end

      def update
        modality_description = find_and_authorize_modality_description
        if modality_description.update(modality_description_params)
          redirect_to modalities_descriptions_path,
                      notice: t(".success", model_name: "modality description")
        else
          flash.now[:error] = t(".failed", model_name: "modality description")
          render_edit(modality_description)
        end
      end

      def destroy
        authorize Description.destroy(params[:id])
        redirect_to modalities_descriptions_path,
                    notice: t(".success", model_name: "modality description")
      end

      private

      def render_new(modality_description)
        render :new, locals: { modality_description: modality_description }
      end

      def render_edit(modality_description)
        render :edit, locals: { modality_description: modality_description }
      end

      def modality_description_params
        params.require(:modalities_description).permit(:name, :code, :site)
      end

      def find_and_authorize_modality_description
        Description.find(params[:id]).tap do |description|
          authorize description
        end
      end
    end
  end
end
