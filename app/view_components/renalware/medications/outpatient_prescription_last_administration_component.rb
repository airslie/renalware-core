module Renalware
  module Medications
    class OutpatientPrescriptionLastAdministrationComponent < ApplicationComponent
      pattr_initialize [:prescription!]

      def last_administration
        return if prescription.blank?

        @last_administration ||=
          OutpatientPrescriptionAdministrationsQuery.call(prescription:).first
      end

      def render?
        last_administration.present?
      end
    end
  end
end
