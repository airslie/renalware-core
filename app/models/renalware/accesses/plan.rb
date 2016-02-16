require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Plan < ActiveRecord::Base
      acts_as_paranoid

      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
