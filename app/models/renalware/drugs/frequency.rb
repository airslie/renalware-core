# frozen_string_literal: true

module Renalware
  module Drugs
    class Frequency < ApplicationRecord
      OTHER_NAME = "other"
      OTHER_TITLE = "Other"

      validates :name, presence: true, uniqueness: true
      validates :title, presence: true

      scope :ordered, -> { order(position: :asc, name: :asc) }

      def self.title_for_name(name)
        # Load all records to avoid N+1 queries, and use Rails cache on selects
        find { |frequency| frequency.name == name }&.title || name
      end
    end
  end
end
