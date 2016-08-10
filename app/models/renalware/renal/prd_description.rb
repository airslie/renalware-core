require_dependency "renalware/renal"

module Renalware
  module Renal
    class PRDDescription < ActiveRecord::Base
      scope :ordered, -> { order(:id) }

      def to_s
        "#{term} [#{code}]"
      end
    end
  end
end
