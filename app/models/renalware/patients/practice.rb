require_dependency "renalware/patients"

module Renalware
  module Patients
    class Practice < ApplicationRecord
      has_one :address, as: :addressable
      has_and_belongs_to_many :primary_care_physicians

      accepts_nested_attributes_for :address, allow_destroy: true

      validates :name, presence: true
      validates :address, presence: true
      validates :code, presence: true
    end
  end
end
