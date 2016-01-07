module Renalware
  class PRDDescription < ActiveRecord::Base
    scope :ordered, -> { order(:id) }

    def to_s
      "#{term} [#{code}]"
    end
  end
end
