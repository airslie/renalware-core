require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class CodesController < BaseController

      before_action :load_modality_code, only: [:edit, :update]

      def new
        @modal_code = Code.new
        authorize @modal_code
      end

      def create
        @modal_code = Code.new(modality_code_params)
        authorize @modal_code

        if @modal_code.save
          redirect_to modalities_codes_path,
            notice: "You have successfully added a new modality."
        else
          render :new
        end
      end

      def index
        @modal_codes = Code.all
        authorize @modal_codes
      end

      def update
        if @modal_code.update(modality_code_params)
          redirect_to modalities_codes_path,
            notice: "You have successfully updated a modality"
        else
          render :edit
        end
      end

      def destroy
        authorize Code.destroy(params[:id])
        redirect_to modalities_codes_path, notice: "You have successfully removed a modality."
      end

      private

      def modality_code_params
        params.require(:modalities_code).permit(:name, :code, :site, :deleted_at)
      end

      def load_modality_code
        @modal_code = Code.find(params[:id])
        authorize @modal_code
      end
    end
  end
end
