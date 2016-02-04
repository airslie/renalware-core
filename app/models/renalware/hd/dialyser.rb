require_dependency "renalware/hd"

module Renalware
  module HD
    class Dialyser < ActiveRecord::Base
      acts_as_paranoid

      validates :group, presence: true
      validates :name, presence: true

      scope :ordered, -> { order(:group, :name) }

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
