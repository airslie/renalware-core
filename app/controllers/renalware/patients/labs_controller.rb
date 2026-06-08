module Renalware
  module Patients
    class LabsController < BaseController
      include Renalware::Concerns::PatientVisibility

      SLOTS = %w(
        lab:patient:top
        lab:patient:middle
        lab:patient:bottom
      ).freeze

      def show
        authorize %i(renalware lab), :show?
        authorize patient

        render locals: {
          patient: patient,
          heidi_link_status: heidi_link_status,
          slots: SLOTS
        }
      end

      private

      def heidi_link_status
        return unless Renalware::Heidi::Client.configured?

        Renalware::Heidi::Client.new.linked_account_access(current_user)
      end
    end
  end
end
