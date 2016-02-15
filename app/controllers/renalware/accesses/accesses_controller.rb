module Renalware
  module Accesses
    class AccessesController < BaseController
      before_filter :load_patient

      def index
      end

      def show
        access = Access.for_patient(@patient).find(params[:id])
        @access = AccessPresenter.new(access)
      end

      def new
        @access = Access.new(patient: @patient, by: current_user)
      end

      def create
        @access = Access.new(patient: @patient)
        @access.attributes = access_params

        if @access.save
          redirect_to patient_accesses_access_path(@patient, @access),
            notice: t(".success", model_name: "Access")
        else
          flash[:error] = t(".failed", model_name: "Access")
          render :new
        end
      end

      def edit
        @access = Access.for_patient(@patient).find(params[:id])
      end

      def update
        @access = Access.for_patient(@patient).find(params[:id])
        @access.attributes = access_params

        if @access.save
          redirect_to patient_accesses_access_path(@patient, @access),
            notice: t(".success", model_name: "Access")
        else
          flash[:error] = t(".failed", model_name: "Access")
          render :edit
        end
      end

      protected

      def access_params
        params.require(:accesses_access)
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
