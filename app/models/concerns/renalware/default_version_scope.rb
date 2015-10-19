require 'active_support/concern'

module Renalware
  module DefaultVersionScope
    extend ActiveSupport::Concern

    included do
      class_eval do
        default_scope { where.not(event: "create") }
      end
    end
  end
end