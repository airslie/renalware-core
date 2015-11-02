require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RegistrationStatus < ActiveRecord::Base
      belongs_to :registration
      belongs_to :description, class_name: "RegistrationStatusDescription"

      scope :ordered, -> (direction=:desc) { order(started_on: direction) }

      def terminated?
        terminated_on.present?
      end

      def to_s
        description.name
      end
    end
  end
end