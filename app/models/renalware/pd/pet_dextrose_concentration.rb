# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class PETDextroseConcentration < ApplicationRecord
      validates :name, presence: true, uniqueness: true

      scope :ordered, -> { order(position: :asc) }
    end
  end
end
