module Renalware
  class User < ActiveRecord::Base
    include Deviseable
    include Permissible
    include Personable

    validates :username, presence: true, uniqueness: true
    validates_presence_of :given_name
    validates_presence_of :family_name
    validate :approval_with_roles, on: :update
    validates_presence_of :professional_position, on: :update, unless: :super_admin_update
    validates_presence_of :signature, on: :update, unless: :super_admin_update

    scope :unapproved, -> { where(approved: [nil, false]) }
    scope :inactive, -> { where('last_activity_at IS NOT NULL AND last_activity_at < ?', expire_after.ago) }
    scope :author, -> { where.not(signature: nil) }
    scope :ordered, -> { order(:given_name, :family_name) }

    # Non-persistent attribute to signify an update by an admin (bypassing some validations)
    attr_accessor :super_admin_update

    def self.policy_class
      UserPolicy
    end

    def self.ransackable_scopes(_auth_object = nil)
      %i(unapproved inactive)
    end

    # @section custom validation methods
    #
    def approval_with_roles
      if self.approved? && self.roles.empty?
        errors.add(:approved, 'approved users must have a role')
      end
    end

  end
end
