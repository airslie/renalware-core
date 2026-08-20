module Renalware
  module Transplants
    class UKTDeathCause < ApplicationRecord
      validates :code, presence: true, uniqueness: true
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true

      scope :enabled, -> { where(enabled: true) }
      scope :ordered, -> { order(position: :asc, name: :asc) }
      scope :enabled_ordered, -> { enabled.ordered }

      def self.pluck_for_dropdown
        enabled_ordered.pluck(:name, :code)
      end

      def to_s = name
    end
  end
end
