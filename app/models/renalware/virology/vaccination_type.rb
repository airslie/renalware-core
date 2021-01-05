# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class VaccinationType < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :code, presence: true, uniqueness: true

      scope :ordered, -> { order(position: :asc, name: :asc) }
    end
  end
end
