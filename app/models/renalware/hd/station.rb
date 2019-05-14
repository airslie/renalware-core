# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class Station < ApplicationRecord
      include Accountable
      belongs_to :location, class_name: "HD::StationLocation", foreign_key: :location_id
      validates :hospital_unit_id, presence: true
      validates :name, uniqueness: { scope: :hospital_unit_id }

      scope :for_unit, ->(id) { where(hospital_unit_id: id) }
      scope :ordered, -> { order(position: :asc) }
    end
  end
end
