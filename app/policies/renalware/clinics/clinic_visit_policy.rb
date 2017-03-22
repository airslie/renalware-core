require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class ClinicVisitPolicy < BasePolicy
      def destroy?
        return false unless record.persisted?
        record.created_at > Renalware.config.new_clinic_visit_deletion_window.ago
      end
    end
  end
end
