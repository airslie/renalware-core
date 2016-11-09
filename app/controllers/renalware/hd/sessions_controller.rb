require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class SessionsController < BaseController
      before_filter :load_patient

      def index
        query = Sessions::PatientQuery.new(patient: patient, q: params[:q])
        sessions = query.call.includes(:hospital_unit, :patient).page(params[:page]).per(15)
        authorize sessions
        presenter = CollectionPresenter.new(sessions, SessionPresenter, view_context)
        @q = query.search
        render :index, locals: { sessions: presenter }
      end

      def show
        session = Session.for_patient(patient).find(params[:id])
        authorize session
        presenter = SessionPresenter.new(session, view_context)
        render :show, locals: { session: presenter, patient: patient }
      end

      def new
        session = SessionFactory.new(patient: patient,
                                     user: current_user,
                                     type: params[:type]).build
        authorize session
        render :new, locals: { session: session, patient: patient }
      end

      def create
        save_session
      end

      def edit
        session = Session.for_patient(patient).find(params[:id])
        authorize session
        render :edit, locals: { session: session, patient: patient }
      rescue Pundit::NotAuthorizedError
        flash[:warning] = t(".session_is_immutable")
        redirect_to patient_hd_session_path(session, patient_id: patient.id)
      end

      def update
        save_session
      end

      def destroy
        session = Session.for_patient(patient).find(params[:id])
        authorize session
        session.destroy!
        message = t(".success", model_name: "HD session")
        redirect_to patient_hd_dashboard_path(patient), notice: message
      end

      def save_session
        command = Sessions::SaveSession.new(patient: patient,
                                            current_user: current_user)
        command.subscribe(self)
        command.call(params: session_params,
                     id: params[:id],
                     signing_off: params[:signoff].present?)
      end

      def save_success(_session)
        url = patient_hd_dashboard_path(patient)
        message = t(".success", model_name: "HD session")
        redirect_to url, notice: message
      end

      def save_failure(session)
        flash[:error] = t(".failed", model_name: "HD session")
        action = action_name.to_sym == :create ? :new : :edit
        render action, locals: { session: session, patient: patient }
      end

      protected

      def session_params
        params.require(:hd_session).require(:type)
        params
          .require(:hd_session)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [:performed_on, :start_time, :end_time,
         :hospital_unit_id, :notes,
         :signed_on_by_id, :signed_off_by_id, :type,
         document: []
        ]
      end

      def document_attributes
        params
          .require(:hd_session)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
