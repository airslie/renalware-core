# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RegistrationStatusDescription < ApplicationRecord
      scope :ordered, -> { order(position: :asc) }

      validates :name, presence: true

      def to_s
        name
      end
    end
  end
end
