module Renalware
  module Accesses
    class ProfilesController < Accesses::BaseController
      before_filter :load_patient

      def show
        profile = @patient.profiles.find(params[:id])
        @profile = ProfilePresenter.new(profile)
      end

      def new
        @profile = @patient.profiles.new(by: current_user)
      end

      def create
        @profile = @patient.profiles.new(profile_params)

        if @profile.save
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access profile")
        else
          flash[:error] = t(".failed", model_name: "Access profile")
          render :new
        end
      end

      def edit
        @profile = @patient.profiles.find(params[:id])
      end

      def update
        @profile = @patient.profiles.find(params[:id])

        if @profile.update(profile_params)
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access profile")
        else
          flash[:error] = t(".failed", model_name: "Access profile")
          render :edit
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
          :formed_on, :started_on, :terminated_on, :planned_on,
          :site_id, :side, :plan_id, :type_id,
          :decided_by_id, :notes
        ]
      end
    end
  end
end
