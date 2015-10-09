module Renalware
  class ModalityCodesController < BaseController

    before_action :load_modality_code, only: [:edit, :update]

    def new
      @modal_code = ModalityCode.new
      authorize @modal_code
    end

    def create
      @modal_code = ModalityCode.new(modality_code_params)
      authorize @modal_code
      if @modal_code.save
        redirect_to modality_codes_path, :notice => "You have successfully added a new modality."
      else
        render :new
      end
    end

    def index
      @modal_codes = ModalityCode.all
      authorize @modal_codes
    end

    def update
      if @modal_code.update(modality_code_params)
        redirect_to modality_codes_path, :notice => "You have successfully updated a modality"
      else
        render :edit
      end
    end

    def destroy
      authorize ModalityCode.destroy(params[:id])
      redirect_to modality_codes_path, :notice => "You have successfully removed a modality."
    end

    private
    def modality_code_params
      params.require(:modality_code).permit(:name, :code, :site, :deleted_at)
    end

    def load_modality_code
      @modal_code = ModalityCode.find(params[:id])
      authorize @modal_code
    end

  end
end