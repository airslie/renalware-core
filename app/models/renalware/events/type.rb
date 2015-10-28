require_dependency 'renalware/events'

module Renalware
  module Events
    class Type < ActiveRecord::Base
      self.table_name = "event_types"

      acts_as_paranoid

      validates :name, presence: true, uniqueness: true

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
