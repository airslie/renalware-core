class ModalityCodesController < ApplicationController

  def new
    @modal_code = ModalityCode.new
  end

  def create
    @modal_code = ModalityCode.new(allowed_params)
    if @modal_code.save
      redirect_to modality_codes_path, :notice => "You have successfully added a new modality."
    else
      render :new
    end
  end

  def index
    @modal_codes = ModalityCode.all
  end

  private
  def allowed_params
    params.require(:modality_code).permit(:name, :code, :deleted_at)
  end

end
