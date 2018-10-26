# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class BatchNumber < ApplicationRecord
      def self.next
        new_batcher_number = new
        new_batcher_number.save!
        new_batcher_number.id.to_s.rjust(6, "0")
      end
    end
  end
end
