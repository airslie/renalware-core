module Renalware
  module HD
    class Anticoagulant < ApplicationRecord
      acts_as_paranoid

      validates :code, presence: true, uniqueness: true
      validates :name, presence: true

      scope :ordered, -> { order(:position, :name) }

      def self.policy_class = BasePolicy

      def to_s = name
    end
  end
end
