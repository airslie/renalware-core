# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class Consultant < ApplicationRecord
      validates :name, presence: true
      scope :ordered, -> { order(name: :asc) }

      def to_s
        name
      end
    end
  end
end
