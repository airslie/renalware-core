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
          slots: SLOTS
        }
      end
    end
  end
end
