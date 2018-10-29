# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class BatchNumber < ApplicationRecord

      def self.next
        create!
      end

      def number
        id.to_s.rjust(6, "0")
      end

      def to_s
        number
      end
    end
  end
end
