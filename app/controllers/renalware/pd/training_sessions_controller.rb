require_dependency "renalware/pd"

module Renalware
  module PD
    class TrainingSessionsController < BaseController

      def show
        training_session = find_training_session
        authorize training_session
        render locals: { patient: patient, training_session: training_session }
      end

      def new
        training_session = PD::TrainingSession.for_patient(patient).new
        authorize training_session
        render locals: { patient: patient, training_session: training_session }
      end

      def create
        training_session = PD::TrainingSession.for_patient(patient).new(training_session_params)
        authorize training_session
        if training_session.save
          redirect_to patient_pd_dashboard_path(patient),
                      notice: success_msg_for("training_session")
        else
          render :new, locals: { patient: patient, training_session: training_session }
        end
      end

      def edit
        training_session = find_training_session
        authorize training_session
        render locals: { patient: patient, training_session: training_session }
      end

      def update
        training_session = find_training_session
        authorize training_session
        if training_session.update(training_session_params)
          redirect_to patient_pd_dashboard_path(patient),
                      notice: success_msg_for("training_session")
        else
          render :edit, locals: { patient: patient, training_session: training_session }
        end
      end

      private

      def find_training_session
        PD::TrainingSession.for_patient(patient).find(params[:id])
      end

      def training_session_params
        params
          .require(:training_session)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [
          document: []
        ]
      end

      def document_attributes
        params.require(:training_session).fetch(:document, nil).try(:permit!)
      end
    end
  end
end
