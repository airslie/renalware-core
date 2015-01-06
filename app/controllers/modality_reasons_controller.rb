class ModalityReasonsController < ApplicationController

  def index
    @reason_hd_pd = HaemodialysisToPd.all
    @reason_pd_hd = PdToHaemodialysis.all
    @modality_reason_select = ModalityReason.where(:type => params[:modal_change_type])
    respond_to do |format|
      format.html
      format.json { render :json => @modality_reason_select.as_json(:only => [:id, :rr_code, :description]) }
    end
  end

end
