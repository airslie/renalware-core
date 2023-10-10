# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionPolicy < BasePolicy
      def new?
        super && user_is_a_prescriber?
      end

      def create?
        super && user_is_a_prescriber?
      end

      def edit?
        super && user_is_a_prescriber?
      end

      def update?
        super && user_is_a_prescriber?
      end

      def destroy?
        super && user_is_a_prescriber?
      end

      private

      def user_is_a_prescriber?
        return true unless Renalware.config.enforce_user_prescriber_flag

        user.has_role?(:prescriber)
      end
    end
  end
end
