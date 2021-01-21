# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RegistrationStatusesController < BaseController
      def new
        status = registration.statuses.build
        authorize status
        render locals: {
          patient: patient,
          status: status
        }
      end

      def create
        status = registration.add_status!(status_params)
        authorize status

        if status.valid?
          redirect_to patient_transplants_recipient_dashboard_path(patient),
                      notice: t(".success", model_name: "registration status")
        else
          flash.now[:error] = t(".failed", model_name: "registration status")
          render :new, locals: { patient: patient, status: status }
        end
      end

      def edit
        status = registration.statuses.find(params[:id])
        authorize status
        render locals: {
          patient: patient,
          status: status
        }
      end

      def update
        status = update_status
        authorize status
        if status.valid?
          redirect_to patient_transplants_recipient_dashboard_path(patient),
                      notice: t(".success", model_name: "registration status")
        else
          flash.now[:error] = t(".failed", model_name: "registration status")
          render :edit, locals: { patient: patient, status: status }
        end
      end

      def destroy
        status = registration.statuses.find(params[:id])
        authorize status
        registration.delete_status!(status)

        redirect_to patient_transplants_recipient_dashboard_path(patient),
                    notice: t(".success", model_name: "registration status")
      end

      protected

      def update_status
        existing_status = registration.statuses.find(params[:id])
        registration.update_status!(existing_status, status_params)
      end

      def registration
        @registration ||= Registration.for_patient(patient).first_or_initialize
      end

      def status_params
        params
          .require(:transplants_registration_status)
          .permit(:started_on, :description_id, :notes)
          .merge(by: current_user)
      end
    end
  end
end
