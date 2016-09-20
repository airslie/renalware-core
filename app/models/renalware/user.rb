module Renalware
  class User < ActiveRecord::Base
    include Deviseable
    include Personable

    has_and_belongs_to_many :roles

    validates :username, presence: true, uniqueness: true
    validates_presence_of :given_name
    validates_presence_of :family_name
    validate :approval_with_roles, on: :update
    validates_presence_of :professional_position, on: :update, unless: :super_admin_update
    validates_presence_of :signature, on: :update, unless: :super_admin_update

    scope :unapproved, -> { where(approved: [nil, false]) }
    scope :inactive, -> { where("last_activity_at IS NOT NULL AND last_activity_at < ?", expire_after.ago) }
    scope :author, -> { where.not(signature: nil) }
    scope :ordered, -> { order(:family_name, :given_name) }

    # Non-persistent attribute to signify an update by an admin (bypassing some validations)
    attr_accessor :super_admin_update

    def self.policy_class
      UserPolicy
    end

    def self.ransackable_scopes(_auth_object = nil)
      %i(unapproved inactive)
    end

    def has_role?(name)
      role_names.include?(name.to_s)
    end

    def role_names
      @role_names ||= roles.pluck(:name)
    end

    private

    def approval_with_roles
      if approved? && roles.empty?
        errors.add(:approved, "approved users must have a role")
      end
    end
  end
end
