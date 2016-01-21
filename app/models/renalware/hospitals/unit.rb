module Renalware
  module Hospitals
    class Unit < ActiveRecord::Base
      extend Enumerize

      belongs_to :hospital_centre, class_name: "Hospitals::Centre"

      validates :hospital_centre, presence: true
      validates :unit_code, presence: true
      validates :name, presence: true
      validates :renal_registry_code, presence: true
      validates :unit_type, presence: true

      enumerize :unit_type, in: %i(hospital satellite home)
    end
  end
end