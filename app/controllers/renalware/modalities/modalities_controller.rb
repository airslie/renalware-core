require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class ModalitiesController < BaseController

      before_filter :load_patient

      def new
        @modality = Modality.new(patient: @patient)
      end

      def index
        @modalities = @patient.modalities.with_deleted.ordered
      end

      def create
        @modality = @patient.set_modality(modality_params)

        if @modality.valid?
          handle_valid_modality
        else
          render :new
        end
      end

      private

      def modality_params
        params.require(:modality).permit(
          :modality_description_id, :modality_change_type,
          :reason_id, :notes, :started_on
        )
      end

      def handle_valid_modality
        if @patient.modality_description.death?
          redirect_to edit_patient_death_path(@patient),
            warning: "Please make sure to update patient date of death and cause of death!"
        else
          redirect_to patient_modalities_path(@patient),
            notice: "Modality successfully created"
        end
      end
    end
  end
end
