# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class Dialysate < ApplicationRecord
      acts_as_paranoid
      validates :name, presence: true, uniqueness: true
      validates :sodium_content, presence: true
      validates :sodium_content_uom, presence: true

      def to_s
        name
      end
    end
  end
end
