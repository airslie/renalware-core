module Renalware
  class LabsController < BaseController
    SLOTS = %w(
      lab:global:top
      lab:global:middle
      lab:global:bottom
    ).freeze

    def show
      authorize %i(renalware lab), :show?

      render locals: {
        patient_scope: visible_patient_scope,
        slots: SLOTS
      }
    end

    private

    def visible_patient_scope
      policy_scope(Patient).select(:id)
    end
  end
end
