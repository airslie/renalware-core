require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RegistrationStatus < ActiveRecord::Base
      belongs_to :registration
      belongs_to :description, class_name: "RegistrationStatusDescription"

      scope :ordered, -> (direction=:desc) { order(started_on: direction) }

      after_initialize :set_defaults, if: :new_record?

      def terminated?
        terminated_on.present?
      end

      def to_s
        description.to_s if description
      end

      protected

      def set_defaults
        self.started_on ||= Time.zone.today
      end
    end
  end
end