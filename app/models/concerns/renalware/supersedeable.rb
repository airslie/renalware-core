require 'active_support/concern'

module Renalware
  module Supersedeable
    extend ActiveSupport::Concern

    included do
      class_eval do
        acts_as_paranoid
      end

      def supersede!(attrs={})
        transaction do
          successor = self.dup
          successor.save!
          self.destroy!
          successor.update_attributes!(attrs) if attrs.any?
          successor
        end
      end
    end
  end
end