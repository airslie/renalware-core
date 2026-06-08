module Renalware
  module Patients
    class HeidiLinkedAccountsController < BaseController
      include Renalware::Concerns::PatientVisibility

      def create
        authorize %i(renalware lab), :show?
        authorize patient

        result = Renalware::Heidi::Client.new.link_account(current_user)
        if result.success?
          redirect_to patient_lab_path(patient), notice: t(".success")
        else
          redirect_to patient_lab_path(patient), alert: t(".failed", error: result.error)
        end
      end
    end
  end
end
