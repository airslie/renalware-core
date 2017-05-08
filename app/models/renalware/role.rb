module Renalware
  class Role < ApplicationRecord
    ROLES = %i(super_admin admin clinician read_only).freeze

    has_and_belongs_to_many :users

    validates_uniqueness_of :name

    def self.fetch(ids)
      return none if Array.wrap(ids).empty?

      find(ids)
    end
  end
end
