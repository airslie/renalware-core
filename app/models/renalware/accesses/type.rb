require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Type < ApplicationRecord
      validates :name, presence: true
      delegate :to_s, to: :name

      scope :ordered, -> { order(:name) }
      scope :having_abbreviation, -> { where.not(abbreviation: nil) }

      def long_name
        abbrev = abbreviation && " (#{abbreviation})"
        "#{name}#{abbrev}"
      end
    end
  end
end
