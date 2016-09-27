require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class SessionsController < BaseController
      before_filter :load_patient

      def index
        query = Sessions::PatientQuery.new(patient: @patient, q: params[:q])
        sessions = query.call.includes(:hospital_unit, :signed_off_by).page(params[:page]).per(15)
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
        @session = session_klass.new(patient: @patient)
        @session.attributes = session_params
        lookup_access_type_abbreviation!(@session)


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
        @session = session_klass.for_patient(@patient).find(params[:id])
        @session.attributes = session_params
        lookup_access_type_abbreviation!(@session)

        if @session.save
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "HD session")
        else
          flash[:error] = t(".failed", model_name: "HD session")
          render :edit
        end
      end

      protected

      # TODO: move to SaveSession class once that PR is in!
      def lookup_access_type_abbreviation!(session)
        return unless session.document

        if (access_type = Accesses::Type.find_by(name: session.document.info.access_type))
          session.document.info.access_type_abbreviation = access_type.abbreviation
        end
      end

      def session_params
        params
          .require(:hd_session)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [ :performed_on, :start_time, :end_time,
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

      def signing_off?
        params[:signoff].present?
      end

      def session_klass
        signing_off? ? HD::Session::Closed : HD::Session
      end
    end
  end
end
