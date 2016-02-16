module Renalware
  module Accesses
    class ProfilesController < BaseController
      before_filter :load_patient

      def index
      end

      def show
        profile = Profile.for_patient(@patient).find(params[:id])
        @profile = ProfilePresenter.new(profile)
      end

      def new
        @profile = Profile.new(patient: @patient, by: current_user)
      end

      def create
        @profile = Profile.new(patient: @patient)
        @profile.attributes = profile_params

        if @profile.save
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access profile")
        else
          flash[:error] = t(".failed", model_name: "Access profile")
          render :new
        end
      end

      def edit
        @profile = Profile.for_patient(@patient).find(params[:id])
      end

      def update
        @profile = Profile.for_patient(@patient).find(params[:id])
        @profile.attributes = profile_params

        if @profile.save
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access profile")
        else
          flash[:error] = t(".failed", model_name: "Access profile")
          render :edit
        end
      end

      protected

      def profile_params
        params.require(:accesses_profile)
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
