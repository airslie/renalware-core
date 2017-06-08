require_dependency "renalware/pd"

module Renalware
  module PD
    class TrainingType < ApplicationRecord
      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def to_s
        name
      end
    end
  end
end
