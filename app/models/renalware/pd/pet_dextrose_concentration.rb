# frozen_string_literal: true

module Renalware
  module PD
    class PETDextroseConcentration < ApplicationRecord
      validates :name, presence: true, uniqueness: true

      scope :ordered, -> { order(position: :asc) }

      def to_s = name
    end
  end
end
