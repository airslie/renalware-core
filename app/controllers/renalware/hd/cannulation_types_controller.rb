require_dependency "renalware/hd"

module Renalware
  module HD
    class CannulationTypesController < BaseController
      before_action :load_cannulation_type, only: [:edit, :update]

      def new
        @cannulation_type = CannulationType.new
        authorize @cannulation_type
      end

      def create
        @cannulation_type = CannulationType.new(event_params)
        authorize @cannulation_type

        if @cannulation_type.save
          redirect_to hd_cannulation_types_path,
            notice: t(".success", model_name: "cannulation type")
        else
          flash[:error] = t(".failed", model_name: "cannulation type")
          render :new
        end
      end

      def index
        @cannulation_types = CannulationType.all
        authorize @cannulation_types
      end

      def update
        if @cannulation_type.update(event_params)
          redirect_to hd_cannulation_types_path,
            notice: t(".success", model_name: "cannulation type")
        else
          flash[:error] = t(".failed", model_name: "cannulation type")
          render :edit
        end
      end

      def destroy
        authorize CannulationType.destroy(params[:id])
        redirect_to hd_cannulation_types_path,
          notice: t(".success", model_name: "cannulation type")
      end

      private

      def event_params
        params.require(:hd_cannulation_type).permit(:name)
      end

      def load_cannulation_type
        @cannulation_type = CannulationType.find(params[:id])
        authorize @cannulation_type
      end
    end
  end
end
