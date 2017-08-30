# To override the values in the location enum use something like this:
# module CustomizeHDStationLocationEnum
#   extend Enumerize
#   enumerize :location, in: %i(side_room ante_room cubicle)
# end
# Renalware::HD::Station.singleton_class.send(:prepend, CustomizeHDStationLocationEnum)
#
require_dependency "renalware/hd"

module Renalware
  module HD
    class Station < ApplicationRecord
      extend Enumerize
      include Accountable
      validates :hospital_unit_id, presence: true
      validates :name, uniqueness: { scope: :hospital_unit_id }

      enumerize :location, in: %i(side_room)

      scope :for_unit, ->(id){ where(hospital_unit_id: id) }
      scope :ordered, ->{ order(position: :asc) }
    end
  end
end
