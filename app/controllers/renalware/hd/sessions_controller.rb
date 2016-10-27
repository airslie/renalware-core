require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class SessionsController < BaseController
      before_filter :load_patient

      def index
        query = Sessions::PatientQuery.new(patient: patient, q: params[:q])
        sessions = query.call.includes(:hospital_unit, :signed_off_by).page(params[:page]).per(15)
        @sessions = CollectionPresenter.new(sessions, SessionPresenter)
        @q = query.search
      end

      def show
        session = Session.for_patient(patient).find(params[:id])
        @session = SessionPresenter.new(session)
      end

      def new
        session = SessionFactory.new(patient: patient,
                                     user: current_user,
                                     type: params[:type]).build
        render :new, locals: { session: session }
      end

      def create
        save_session
      end

      def edit
        session = Session.for_patient(patient).find(params[:id])
        render :edit, locals: { session: session }
      end

      def update
        save_session
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
        render action, locals: { session: session }
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
        [ :performed_on, :start_time, :end_time,
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
