# frozen_string_literal: true

module Renalware
  class Role < ApplicationRecord
    ROLES = %i(devops super_admin admin clinical read_only prescriber hd_prescriber).freeze

    has_many :roles_users, dependent: :destroy
    has_many :users, through: :roles_users

    validates :name, uniqueness: true

    def self.fetch(ids)
      return none if Array.wrap(ids).empty?

      find(ids)
    end

    def self.install!
      ROLES.each do |role|
        hidden = [:super_admin, :devops].include?(role)
        Role.find_or_create_by!(name: role, hidden: hidden)
      end
    end
  end
end
