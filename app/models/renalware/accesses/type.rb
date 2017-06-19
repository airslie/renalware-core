require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Type < ApplicationRecord
      validates :name, presence: true

      scope :ordered, -> { order(:name) }
      scope :having_abbreviation, -> { where.not(abbreviation: nil) }

      def to_s
        abbrev = abbreviation && " (#{abbreviation})"
        "#{name}#{abbrev}"
      end
    end
  end
end
