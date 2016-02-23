require_dependency "renalware/problems"

module Renalware
  module Problems
    class Note < ActiveRecord::Base
      include Accountable

      belongs_to :problem

      scope :ordered, ->() { order(created_at: :asc) }

      validates :description, presence: true
    end
  end
end
