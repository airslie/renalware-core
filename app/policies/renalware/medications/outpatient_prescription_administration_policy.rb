module Renalware
  module Medications
    class OutpatientPrescriptionAdministrationPolicy < BasePolicy
      def destroy? = user_is_any_admin?
    end
  end
end
