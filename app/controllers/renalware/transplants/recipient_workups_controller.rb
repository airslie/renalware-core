require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RecipientWorkupsController < BaseController

      before_filter :load_patient

      def show
        @workup = RecipientWorkup.for_patient(@patient).first_or_initialize

        redirect_to edit_patient_transplants_recipient_workup_path(@patient) if @workup.new_record?
      end

      def edit
        @workup = RecipientWorkup.for_patient(@patient).first_or_initialize
      end

      def update
        @workup = RecipientWorkup.for_patient(@patient).first_or_initialize

        if @workup.update_attributes workup_params
          redirect_to patient_transplants_recipient_workup_path(@patient),
            notice: t(".success", model_name: "recipient work up")
        else
          flash[:error] = t(".failed", model_name: "recipient work up")
          render :edit
        end
      end

      private

      def workup_params
        params
          .require(:transplants_recipient_workup)
          .permit
          .merge(document: document_attributes)
      end

      def document_attributes
        params
          .require(:transplants_recipient_workup)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
