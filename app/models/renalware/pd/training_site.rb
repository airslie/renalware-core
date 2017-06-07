require_dependency "renalware/pd"

module Renalware
  module PD
    class TrainingSite < ApplicationRecord
      validates :code, presence: true
      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def to_s
        name
      end
    end
  end
end
