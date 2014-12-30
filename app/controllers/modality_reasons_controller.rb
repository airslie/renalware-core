class ModalityReasonsController < ApplicationController

  def index
    @modality_reason_select = ModalityReason.where(:type => params[:modal_change_type])
    respond_to do |format|
      format.html
      format.json { render :json => @modality_reason_select.as_json(:only => [:id, :description]) }
    end
  end

end
