# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class Type < ApplicationRecord
      self.table_name = "event_types"
      DEFAULT_EVENT_CLASS_NAME = "Renalware::Events::Simple"

      acts_as_paranoid

      validates :name, presence: true, uniqueness: true
      validates :slug,
                format: {
                  with: /\A[0-9a-z\-\_]+\z/i,
                  case_sensitive: false
                },
                uniqueness: true,
                allow_nil: true

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end

      def event_class_name
        super || DEFAULT_EVENT_CLASS_NAME
      end
    end
  end
end
