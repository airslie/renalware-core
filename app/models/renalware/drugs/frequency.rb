# frozen_string_literal: true

module Renalware
  module Drugs
    class Frequency < ApplicationRecord
      OTHER_NAME = "other"
      OTHER_TITLE = "Other"

      validates :name, presence: true
      validates :title, presence: true

      def self.title_for_name(name)
        # Load all records to avoid N+1 queries, and use Rails cache on selects
        all.find { |frequency| frequency.name == name }&.title || name
      end
    end
  end
end
