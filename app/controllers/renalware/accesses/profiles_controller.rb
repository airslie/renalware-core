module Renalware
  module Accesses
    class ProfilesController < Accesses::BaseController
      before_action :load_patient

      def show
        profile = patient.profiles.find(params[:id])
        presenter = ProfilePresenter.new(profile)
        render locals: { patient: patient, profile: presenter }
      end

      def new
        profile = patient.profiles.new(by: current_user)
        render locals: { patient: patient, profile: profile }
      end

      def create
        profile = patient.profiles.new(profile_params)

        if profile.save
          redirect_to patient_accesses_dashboard_path(patient),
            notice: t(".success", model_name: "Access profile")
        else
          flash.now[:error] = t(".failed", model_name: "Access profile")
          render :new, locals: { patient: patient, profile: profile }
        end
      end

      def edit
        profile = patient.profiles.find(params[:id])
        render locals: { patient: patient, profile: profile }
      end

      def update
        profile = patient.profiles.find(params[:id])

        if profile.update(profile_params)
          redirect_to patient_accesses_dashboard_path(patient),
            notice: t(".success", model_name: "Access profile")
        else
          flash.now[:error] = t(".failed", model_name: "Access profile")
          render :edit, locals: { patient: patient, profile: profile }
        end
      end

      protected

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
