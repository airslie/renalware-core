module Renalware
  module HD
    class SessionsController < BaseController
      before_filter :load_patient
      before_filter :load_bookmark

      def index
        query = Sessions::PatientQuery.new(patient: @patient, q: params[:q])
        sessions = query.call.page(params[:page]).per(15)
        @sessions = CollectionPresenter.new(sessions, SessionPresenter)
        @q = query.search
      end

      def show
        session = Session.for_patient(@patient).find(params[:id])
        @session = SessionPresenter.new(session)
      end

      def new
        @session = SessionFactory.new(patient: @patient, user: current_user).build
      end

      def create
        @session = Session.new(patient: @patient)
        @session.attributes = session_params

        if @session.save
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "HD session")
        else
          flash[:error] = t(".failed", model_name: "HD session")
          render :new
        end
      end

      def edit
        @session = Session.for_patient(@patient).find(params[:id])
      end

      def update
        @session = Session.for_patient(@patient).find(params[:id])
        @session.attributes = session_params

        if @session.save
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "HD session")
        else
          flash[:error] = t(".failed", model_name: "HD session")
          render :edit
        end
      end

      protected

      def session_params
        params
          .require(:hd_session)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [
          :performed_on, :start_time, :end_time,
          :hospital_unit_id, :notes,
          :signed_on_by_id, :signed_off_by_id,
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
