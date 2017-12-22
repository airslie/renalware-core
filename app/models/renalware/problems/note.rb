require_dependency "renalware/problems"

module Renalware
  module Problems
    class Note < ApplicationRecord
      include Accountable

      belongs_to :problem, touch: true

      scope :ordered, -> { order(created_at: :asc) }

      validates :description, presence: true
    end
  end
end
