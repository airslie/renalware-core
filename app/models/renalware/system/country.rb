require_dependency "renalware/system"

module Renalware
  module System
    class Country < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :alpha2, presence: true, uniqueness: true
      validates :alpha3, presence: true, uniqueness: true
    end
  end
end
