# frozen_string_literal: true

require "attr_extras"

module Renalware
  module HD
    class ProfilesInDateRangeQuery
      pattr_initialize [:patient!, :from!, :to!]

      def call
        scope = Renalware::HD::Profile
          .with_deactivated
          .order(created_at: :asc, deactivated_at: :desc)

        scope
          .where(conditions.merge(deactivated_at: from..to))
          .or(scope.where(conditions.merge(deactivated_at: nil)))
        # .where(conditions.merge(deactivated_at: from..to))
        # .or(scope.where(conditions.merge(deactivated_at: nil)))
      end

      private

      # created_at: from..DateTime::Infinity.new
      def conditions
        {
          patient_id: patient.id,
          created_at: from..(to || DateTime::Infinity.new)
        }
      end
    end
  end
end
