module Renalware
  module Medications
    class OutpatientPrescriptionAdministrationPolicy < BasePolicy
      def index? = enabled? && super
      def new? = enabled? && super
      def create? = enabled? && super
      def edit? = enabled? && super
      def update? = enabled? && super
      def destroy? = enabled? && user_is_any_admin?

      private

      def enabled?
        Renalware.config.outpatient_prescription_administration_enabled
      end
    end
  end
end
