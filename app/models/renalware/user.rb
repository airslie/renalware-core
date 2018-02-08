module Renalware
  class User < ApplicationRecord
    include Deviseable
    include Personable

    has_many :roles_users, dependent: :destroy
    has_many :roles, through: :roles_users

    validates :username, presence: true, uniqueness: true
    validates :given_name, presence: true
    validates :family_name, presence: true
    validate :approval_with_roles, on: :update
    validates :professional_position, presence: {
      on: :update,
      if: ->(user){ user.with_extended_validation }
    }
    validates :signature, presence: {
      on: :update,
      if: ->(user){ user.with_extended_validation }
    }

    scope :unapproved, -> { where(approved: [nil, false]) }
    scope :inactive, lambda {
      where("last_activity_at IS NOT NULL AND last_activity_at < ?", expire_after.ago)
    }
    scope :author, -> { where.not(signature: nil) }
    scope :ordered, -> { order(:family_name, :given_name) }
    scope :excluding_system_user, -> { where.not(username: SystemUser.username) }
    scope :with_no_role, lambda {
      left_joins(:roles)
        .distinct("roles_users.user_id")
        .where("roles_users.user_id is null")
    }

    # Non-persistent attribute to signify we want to use extended validation.
    # We need to refactor this by ising a form object for updating a user.
    attr_accessor :with_extended_validation

    def self.policy_class
      UserPolicy
    end

    def self.ransackable_scopes(_auth_object = nil)
      %i(unapproved inactive)
    end

    # rubocop:disable Naming/PredicateName
    def has_role?(name)
      role_names.include?(name.to_s)
    end
    # rubocop:enable Naming/PredicateName

    def role_names
      @role_names ||= roles.pluck(:name)
    end

    # Official name for use when displaying e.g. on a letter. For example:
    #   Dr Isaac Newton (Consultant Gravitationalist)
    def professional_signature
      signed = signature || full_name
      signed += " (#{professional_position})" if professional_position?
      signed
    end

    def generate_new_authentication_token!
      build_authentication_token.tap do |token|
        update_column(:authentication_token, token)
      end
    end

    private

    def build_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.find_by(authentication_token: token)
      end
    end

    def approval_with_roles
      if approved? && roles.empty?
        errors.add(:approved, "approved users must have a role")
      end
    end
  end
end
