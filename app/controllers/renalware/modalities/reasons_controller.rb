require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class ReasonsController < BaseController
      skip_after_action :verify_authorized

      def index
        @reason_hd_pd = HaemodialysisToPD.all
        @reason_pd_hd = PDToHaemodialysis.all

        type = params[:modal_change_type] ?
          "Renalware::Modalities::#{params[:modal_change_type].camelize}" : nil
        @modality_reason_select = Reason.where(type: type)

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
