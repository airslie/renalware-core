# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class StationLocation < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :colour, presence: true
    end
  end
end
