require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class ReasonsController < BaseController

      def index
        @reason_hd_pd = HaemodialysisToPD.all
        authorize @reason_hd_pd

        @reason_pd_hd = PDToHaemodialysis.all
        authorize @reason_pd_hd

        type = params[:modal_change_type] ? "Renalware::Modalities::#{params[:modal_change_type]}" : nil
        @modality_reason_select = Reason.where(type: type)
        authorize @modality_reason_select

        respond_to do |format|
          format.html
          format.json {
            render json: @modality_reason_select.as_json(only: [:id, :rr_code, :description])
          }
        end
      end

    end
  end
end
