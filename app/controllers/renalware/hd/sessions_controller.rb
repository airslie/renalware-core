# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"
require "collection_presenter"

module Renalware
  module HD
    class SessionsController < BaseController
      include PresenterHelper
      include Renalware::Concerns::Pageable

      before_action :load_patient

      def index
        query = sessions_query
        sessions = query
          .call
          .eager_load(:hospital_unit, :patient, :signed_on_by, :signed_off_by)
          .page(page)
          .per(per_page || 15)
        authorize sessions
        presenter = CollectionPresenter.new(sessions, SessionPresenter, view_context)
        @q = query.search
        render :index, locals: { patient: patient, sessions: presenter }
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
        render :new, locals: locals(session)
      end

      def create
        save_session
      end

      def edit
        session = Session.for_patient(patient).find(params[:id])
        authorize session
        render :edit, locals: locals(session)
      rescue Pundit::NotAuthorizedError
        flash[:warning] = t(".session_is_immutable")
        redirect_to patient_hd_session_path(session, patient_id: patient)
      end

      def update
        save_session
      end

      def destroy
        session = Session.for_patient(patient).find(params[:id])
        authorize session
        session.destroy!
        regenerate_rolling_hd_statistics
        message = success_msg_for("HD session")
        redirect_to patient_hd_dashboard_path(patient), notice: message
      end

      def save_session
        command = Sessions::SaveSession.new(patient: patient, current_user: current_user)
        command.subscribe(self)
        command.call(params: session_params,
                     id: params[:id],
                     signing_off: params[:signoff].present?)
      end

      def save_success(_session)
        url = patient_hd_dashboard_path(patient)
        message = success_msg_for("HD session")
        redirect_to url, notice: message
      end

      def save_failure(session)
        flash.now[:error] = failed_msg_for("HD session")
        action = action_name.to_sym == :create ? :new : :edit
        render action, locals: locals(session)
      end

      protected

      def locals(session)
        {
          session: session,
          patient: patient
        }
      end

      def sessions_query
        Sessions::PatientQuery.new(patient: patient, q: params[:q])
      end

      def session_params
        @session_params ||= begin
          params.require(:hd_session).require(:type)
          params.require(:hd_session)
                        .permit(attributes)
                        .merge(document: document_attributes, by: current_user)
        end
      end

      def attributes
        [:performed_on, :start_time, :end_time,
         :hospital_unit_id, :hd_station_id, :notes, :dialysate_id,
         :signed_on_by_id, :signed_off_by_id, :type,
         document: []]
      end

      def document_attributes
        params
          .require(:hd_session)
          .fetch(:document, nil)
          .try(:permit!)
      end

      def regenerate_rolling_hd_statistics
        Delayed::Job.enqueue UpdateRollingPatientStatisticsDjJob.new(patient.id)
      end
    end
  end
end
