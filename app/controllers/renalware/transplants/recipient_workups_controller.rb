module Renalware
  module Transplants
    class RecipientWorkupsController < BaseController
      before_filter :load_patient

      def index
        @workups = RecipientWorkup.all
      end

      def new
        @workup = RecipientWorkup.new(patient: @patient)
      end

      def create
        @workup = RecipientWorkup.new(workup_params.merge(patient: @patient))

        if @workup.save
          redirect_to patient_transplants_recipient_workups_path(@patient)
        else
          render :new
        end
      end

      def edit
        @workup = RecipientWorkup.for_patient(@patient).find params[:id]
      end

      def update
        @workup = RecipientWorkup.for_patient(@patient).find params[:id]

        if @workup.update_attributes workup_params
          redirect_to patient_transplants_recipient_workups_path(@patient)
        else
          render :edit
        end
      end

      def destroy
        @workup = RecipientWorkup.for_patient(@patient).find params[:id]
        @workup.destroy
        redirect_to patient_transplants_recipient_workups_path(@patient)
      end

      protected

      def workup_params
        fields = [
          :performed_at, :notes,
          { document_attributes: RecipientWorkupDocument.fields }
        ]
        params.require(:transplants_recipient_workup).permit(fields)
      end
    end
  end
end
