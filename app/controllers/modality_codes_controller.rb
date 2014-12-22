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

  def edit
    @modal_code = ModalityCode.find(params[:id])
  end

  def update
    @modal_code = ModalityCode.find(params[:id])
    if @modal_code.update(allowed_params)
      redirect_to modality_codes_path, :notice => "You have successfully updated a modality"
    else
      render :edit
    end
  end

  def destroy
    @modal_code = ModalityCode.find(params[:id])
    @modal_code.soft_delete!
    redirect_to modality_codes_path, :notice => "You have successfully removed a modality."
  end

  private
  def allowed_params
    params.require(:modality_code).permit(:name, :code, :deleted_at)
  end

end
