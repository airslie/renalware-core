# frozen_string_literal: true

module Renalware
  module Accesses
    class ProfilesController < Accesses::BaseController
      def show
        profile = find_profile
        presenter = ProfilePresenter.new(profile)
        render locals: { patient: patient, profile: presenter }
      end

      def new
        profile = patient.profiles.new(by: current_user)
        authorize profile
        render locals: { patient: patient, profile: profile }
      end

      def create
        profile = patient.profiles.new(profile_params)
        authorize profile

        if profile.save
          redirect_to patient_accesses_dashboard_path(patient),
                      notice: success_msg_for("Access profile")
        else
          flash.now[:error] = failed_msg_for("Access profile")
          render :new, locals: { patient: patient, profile: profile }
        end
      end

      def edit
        profile = find_profile
        render locals: { patient: patient, profile: profile }
      end

      def update
        profile = find_profile

        if profile.update(profile_params)
          redirect_to patient_accesses_dashboard_path(patient),
                      notice: success_msg_for("Access profile")
        else
          flash.now[:error] = failed_msg_for("Access profile")
          render :edit, locals: { patient: patient, profile: profile }
        end
      end

      protected

      def find_profile
        patient.profiles.find(params[:id]).tap { |prof| authorize(prof) }
      end

      def profile_params
        params
          .require(:accesses_profile)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :formed_on, :started_on, :terminated_on, :side, :type_id, :notes
        ]
      end
    end
  end
end
