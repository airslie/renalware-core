module Renalware
  class Role < ApplicationRecord
    ROLES = %i(devops super_admin admin clinician read_only).freeze

    has_and_belongs_to_many :users, join_table: :roles_users

    validates :name, uniqueness: true

    def self.fetch(ids)
      return none if Array.wrap(ids).empty?

      find(ids)
    end
  end
end
