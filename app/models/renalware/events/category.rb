# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class Category < ApplicationRecord
      self.table_name = "event_categories"
      acts_as_paranoid
      has_many :types, dependent: :nullify
      validates :name, presence: true, uniqueness: true

      def to_s
        name
      end
    end
  end
end
