module Renalware
  class HospitalUnit < ActiveRecord::Base
    extend Enumerize

    belongs_to :hospital

    validates :hospital, presence: true
    validates :unit_code, presence: true
    validates :name, presence: true
    validates :renal_registry_code, presence: true
    validates :unit_type, presence: true

    enumerize :unit_type, in: %i(hospital satellite home)
  end
end