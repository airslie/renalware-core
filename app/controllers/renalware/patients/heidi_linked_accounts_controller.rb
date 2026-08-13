module Renalware
  module Patients
    class HeidiLinkedAccountsController < BaseController
      include Renalware::Concerns::PatientVisibility

      def show
        authorize %i(renalware lab), :show?
        authorize patient

        result = Renalware::Heidi::Client.new.linked_account_access(current_user)
        if result.success?
          render json: result.body
        else
          render json: { is_linked: false, error: result.error }, status: :bad_gateway
        end
      end

      def create
        authorize %i(renalware lab), :show?
        authorize patient

        result = Renalware::Heidi::Client.new.link_account_url_for(current_user)
        if result.success?
          redirect_to result.body.fetch("url"), allow_other_host: true
        else
          redirect_to patient_lab_path(patient), alert: t(".failed", error: result.error)
        end
      end
    end
  end
end
