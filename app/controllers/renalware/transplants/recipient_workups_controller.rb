module Renalware
  module Transplants
    class RecipientWorkupsController < BaseController
      before_filter :load_patient

      def show
        @workup = RecipientWorkup.for_patient(@patient)
        redirect_to edit_patient_transplants_recipient_workup_path(@patient) if @workup.new_record?
      end

      def edit
        @workup = RecipientWorkup.for_patient(@patient)
      end

      def update
        @workup = RecipientWorkup.for_patient(@patient)

        if @workup.update_attributes workup_params
          redirect_to patient_transplants_recipient_workup_path(@patient)
        else
          render :edit
        end
      end

      protected

      def workup_params
        fields = [
          { document_attributes: RecipientWorkup.embedded_attributes }
        ]
        params.require(:transplants_recipient_workup).permit(fields)
      end
    end
  end
end
