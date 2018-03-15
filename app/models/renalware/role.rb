# frozen_string_literal: true

module Renalware
  class Role < ApplicationRecord
    ROLES = %i(devops super_admin admin clinical read_only).freeze

    has_many :roles_users, dependent: :destroy
    has_many :users, through: :roles_users

    validates :name, uniqueness: true

    def self.fetch(ids)
      return none if Array.wrap(ids).empty?

      find(ids)
    end
  end
end
