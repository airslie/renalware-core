module Renalware
  class EventType < ActiveRecord::Base
    acts_as_paranoid

    has_many :events

    validates :name, presence: true

    def self.policy_class
      BasePolicy
    end
  end
end