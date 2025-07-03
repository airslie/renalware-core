require "active_support/concern"

module Renalware
  module OrderedScope
    extend ActiveSupport::Concern

    included do
      def self.ordered
        order(self::ORDER_FIELDS.map { |key| { key => :desc } })
      end
    end
  end
end
