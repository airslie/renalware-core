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
        enforce = [:prescriber, :hd_prescriber].include?(role)
        Role.find_or_create_by!(name: role, hidden: hidden, enforce: enforce)
      end
    end

    # If we want for example to say that the Prescriber role is enforced - so only users
    # with that role can prescribe - then we can set the enforce=true flag on that role.
    # We cache the enforcement of roles for the lifetime of the app ie changes to the value of
    # 'role.enforced' are not reflected in the app until it is restarted.
    # Note enforce has no affect on roles like superadmin - ie 'permission-level' roles.
    #
    # Usage to test if a role is enforced:
    #
    #   Renalware::Role.enforce?(:prescriber)
    #
    def self.enforce?(name)
      ActiveModel::Type::Boolean.new.cast(role_enforcement_hash[name.to_s])
    end

    def self.generate_role_enforcement_hash = Renalware::Role.pluck(:name, :enforce).to_h

    def self.role_enforcement_hash
      return generate_role_enforcement_hash if Rails.env.test? || Rails.env.development?

      @role_enforcement_hash ||= generate_role_enforcement_hash
    end
  end
end
