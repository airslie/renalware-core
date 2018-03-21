# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class PRDDescription < ApplicationRecord
      scope :ordered, -> { order(:id) }

      def to_s
        "#{term} [#{code}]"
      end
    end
  end
end
