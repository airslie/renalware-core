module Renalware
  class ModalityCodesController < BaseController
    load_and_authorize_resource

    def new
      @modal_code = ModalityCode.new
    end

    def create
      @modal_code = ModalityCode.new(modality_code_params)
      if @modal_code.save
        redirect_to modality_codes_path, :notice => "You have successfully added a new modality."
      else
        render :new
      end
    end

    def index
      @modal_codes = ModalityCode.all
    end

    def edit
      @modal_code = ModalityCode.find(params[:id])
    end

    def update
      @modal_code = ModalityCode.find(params[:id])
      if @modal_code.update(modality_code_params)
        redirect_to modality_codes_path, :notice => "You have successfully updated a modality"
      else
        render :edit
      end
    end

    def destroy
      ModalityCode.destroy(params[:id])
      redirect_to modality_codes_path, :notice => "You have successfully removed a modality."
    end

    private

    def modality_code_params
      params.require(:modality_code).permit(:name, :code, :site, :deleted_at)
    end

  end
end