# frozen_string_literal: true

# Global visits not scoped to a patient
module Renalware
  module Clinics
    class ClinicsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        clinics = Clinic.with_deleted.ordered
        authorize clinics
        render locals: { clinics: clinics }
      end

      def new
        clinic = Clinic.new
        authorize clinic
        render locals: { clinic: clinic }
      end

      def create
        clinic = Clinic.new(clinic_params.merge(by: current_user))
        authorize clinic
        if clinic.save
          redirect_to clinics_path
        else
          render "new", locals: { clinic: clinic }
        end
      end

      def edit
        render locals: { clinic: find_and_authorise_clinic }
      end

      def update
        clinic = find_and_authorise_clinic
        if clinic.update(clinic_params.merge(by: current_user))
          redirect_to clinics_path
        else
          render "edit", locals: { clinic: clinic }
        end
      end

      def destroy
        clinic = find_and_authorise_clinic
        clinic.update!(by: current_user)
        clinic.destroy
        redirect_to clinics_path, notice: success_msg_for("clinic")
      end

      private

      def clinic_params
        params.require(:clinic).permit(:name, :code)
      end

      def find_and_authorise_clinic
        Clinic.find(params[:id]).tap { |clinic| authorize(clinic) }
      end
    end
  end
end
