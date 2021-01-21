# frozen_string_literal: true

require "devise"

module Renalware
  class User < ApplicationRecord
    include Deviseable
    include Personable

    has_many :roles_users, dependent: :destroy
    has_many :roles, through: :roles_users
    belongs_to :hospital_centre, class_name: "Renalware::Hospitals::Centre"

    validates :username, presence: true, uniqueness: true
    validates :given_name, presence: true
    validates :family_name, presence: true
    validate :approval_with_roles, on: :update
    validates :professional_position, presence: {
      on: :update,
      if: ->(user) { user.with_extended_validation }
    }
    validates :signature, presence: {
      on: :update,
      if: ->(user) { user.with_extended_validation }
    }

    scope :unapproved, -> { where(approved: [nil, false]) }
    scope :expired, -> { where.not(expired_at: nil) }
    scope :inactive, lambda {
      where("last_activity_at IS NOT NULL AND last_activity_at < ?", expire_after.ago)
    }
    scope :excludable, -> { unapproved.or(inactive).or(expired).or(hidden) }
    scope :author, -> { where.not(signature: nil) }
    scope :ordered, -> { order(:family_name, :given_name) }
    scope :excluding_system_user, -> { where.not(username: SystemUser.username) }
    scope :with_no_role, lambda {
      left_outer_joins(:roles)
        .distinct("roles_users.user_id")
        .where("roles_users.user_id is null")
    }
    scope :consultants, -> { where(consultant: true).excluding_system_user.ordered }
    scope :visible, -> { where(hidden: false) }
    scope :hidden, -> { where(hidden: true) }
    scope :picklist, -> { visible.ordered }

    store_accessor :preferences, :experimental_features

    # Non-persistent attribute to signify we want to use extended validation.
    # We need to refactor this by ising a form object for updating a user.
    attr_accessor :with_extended_validation

    def self.policy_class
      UserPolicy
    end

    # So we can uses these scopes as Ransack predicates eg. { expired: true }
    def self.ransackable_scopes(_auth_object = nil)
      %i(unapproved inactive expired)
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

    # Create a sha that can be saved in another model to indicate a user has authenticated
    # (or perhaps more correctly, authorised) an action - e.g. in HD Session form where a nurse
    # and witness both enter their credentials against a prescription administered on HD.
    # The idea is that we can check the token belongs to the user buy regenerating the token at any
    # time and checking it still matches. Unlike Devise.friendly_token, we can always regenerate
    # the same token here for any user as it is salted with the same secret. This secret is not
    # stored git for staging and production environments.
    def auth_token
      digest = OpenSSL::Digest.new("sha256")
      key = Rails.application.secrets.secret_key_base
      OpenSSL::HMAC.hexdigest(digest, key, id.to_s)
    end

    # We implement a simple can? method ion the use because in places we pass a current user
    # from an ActionView::Component to a partial, and in the specs the partial says it cannot
    # Example usage user.can?(:edit, letter)
    # def can?(method, record)
    #   method = :"#{method}?" unless method.to_s.ends_with("?")
    #   Pundit.policy(self, record).public_send(method.to_sym)
    # end

    # We can enable experiment features for particular users using the bitmask user#feature_flags
    # property and bitwise operators.
    # For example given the the feature flag FANCY_GRAPHS = 2, we if they user should see these with
    #   FANCY_GRAPHS & feature_flags == FANCY_GRAPHS
    def wants_feature?(flag)
      (flag & feature_flags) == flag
    end

    private

    def build_authentication_token
      loop do
        token = ::Devise.friendly_token
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
