# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionPolicy < BasePolicy
      def new?
        super && prescriber?
      end

      def create?
        super && prescriber?
      end

      def edit?
        super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      end

      def update?
        super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      end

      def destroy?
        super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      end

      def new_hd_prescription?
        hd_prescriber?
      end

      private

      def hd_prescriber?
        return true unless Role.enforce?(:hd_prescriber)

        user_is_hd_prescriber? || user_is_super_admin?
      end

      def prescriber?
        return true unless Role.enforce?(:prescriber)

        user_is_prescriber? || user_is_hd_prescriber? || user_is_super_admin?
      end

      def administer_on_hd?
        record&.administer_on_hd
      end
    end
  end
end
