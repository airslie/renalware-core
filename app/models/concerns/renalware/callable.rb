# frozen_string_literal: true

module Renalware
  module Callable
    # Adds a #call class method that will instantiate the class, passing any args to #initialize,
    # and then invoke instance#call (without args).
    extend ActiveSupport::Concern

    included do
      def self.call(...)
        new(...).call
      end
    end
  end
end
