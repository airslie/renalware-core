require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class HistoryController < Renalware::BaseController

      def update
        authorize patient
        patient.document.history.attributes = history_params.symbolize_keys
        patient.by = current_user
        if patient.save
          redirect_to :back, notice: t(".success", model_name: "clinical history")
        else
          raise NotImplementedError
        end
      end

      private

      def history_params
        params.require(:history).permit([:smoking, :alcohol])
      end
    end
  end
end
