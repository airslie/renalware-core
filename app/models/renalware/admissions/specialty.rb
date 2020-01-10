# frozen_string_literal: true

require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Specialty < ApplicationRecord
      validates :name, presence: true, uniqueness: true

      scope :ordered, -> { order(position: :asc) }

      def to_s
        name
      end
    end
  end
end
