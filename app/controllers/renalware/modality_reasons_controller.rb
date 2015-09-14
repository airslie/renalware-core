module Renalware
  class ModalityReasonsController < BaseController
    load_and_authorize_resource

    def index
      @reason_hd_pd = HaemodialysisToPd.all
      @reason_pd_hd = PdToHaemodialysis.all
      type = params[:modal_change_type] ? "Renalware::#{params[:modal_change_type]}" : nil
      @modality_reason_select = ModalityReason.where(:type => type)
      respond_to do |format|
        format.html
        format.json { render :json => @modality_reason_select.as_json(:only => [:id, :rr_code, :description]) }
      end
    end

  end
end