require_dependency "renalware/deaths"

module Renalware
  module Modalities
    class ModalitiesController < BaseController

      before_action :load_patient

      def new
        modality = Modality.new(patient: patient)
        render locals: { patient: patient, modality: modality }
      end

      def index
        modalities = patient.modalities.ordered
        render locals: { patient: patient, modalities: modalities }
      end

      def create
        modality = Modality.new(modality_params.merge!(patient: patient))

        if modality.valid?
          patient.set_modality(modality_params)
          handle_valid_modality
        else
          flash.now[:error] = t(".failed", model_name: "modality")
          render :new, locals: { patient: patient, modality: modality }
        end
      end

      private

      def params_are_valid?
        Modality.new(modality_params).valid?
      end

      def modality_params
        params.require(:modality)
        .permit(
          :description_id, :modal_change_type,
          :reason_id, :notes, :started_on
        ).merge(by: current_user)
      end

      def handle_valid_modality
        if patient.modality_description.is_a? Deaths::ModalityDescription
          redirect_to edit_patient_death_path(patient), flash: {
            warning: "Please make sure to update patient date of death and cause of death!"
          }
        elsif patient.modality_description.is_a? Transplants::DonorModalityDescription
          redirect_to new_patient_transplants_donation_path(patient), flash: {
            warning: "If you have the information on-hand, please enter the potential donation."
          }
        else
          redirect_to patient_modalities_path(patient),
            notice: t(".success", model_name: "modality")
        end
      end
    end
  end
end
