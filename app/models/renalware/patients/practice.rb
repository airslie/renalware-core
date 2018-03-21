# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class Practice < ApplicationRecord
      acts_as_paranoid

      has_one :address, as: :addressable
      has_many :practice_memberships
      has_many :primary_care_physicians, through: :practice_memberships

      accepts_nested_attributes_for :address, allow_destroy: true

      validates :name, presence: true
      validates :address, presence: true
      validates :code, presence: true
    end
  end
end
