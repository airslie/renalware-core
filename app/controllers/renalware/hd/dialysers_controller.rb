require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DialysersController < BaseController
      before_action :load_dialyser, only: [:edit, :update]

      def new
        @dialyser = Dialyser.new
        authorize @dialyser
      end

      def create
        @dialyser = Dialyser.new(dialyser_params)
        authorize @dialyser

        if @dialyser.save
          redirect_to hd_dialysers_path,
            notice: t(".success", model_name: "dialyser")
        else
          flash[:error] = t(".failed", model_name: "dialyser")
          render :new
        end
      end

      def index
        @dialysers = Dialyser.all
        authorize @dialysers
      end

      def update
        if @dialyser.update(dialyser_params)
          redirect_to hd_dialysers_path,
            notice: t(".success", model_name: "dialyser")
        else
          flash[:error] = t(".failed", model_name: "dialyser")
          render :edit
        end
      end

      def destroy
        authorize Dialyser.destroy(params[:id])
        redirect_to hd_dialysers_path,
          notice: t(".success", model_name: "dialyser")
      end

      private

      def dialyser_params
        params.require(:hd_dialyser).permit(:group, :name)
      end

      def load_dialyser
        @dialyser = Dialyser.find(params[:id])
        authorize @dialyser
      end
    end
  end
end
