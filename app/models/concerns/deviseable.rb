require 'active_support/concern'

module Deviseable
  extend ActiveSupport::Concern

  included do
    class_eval do
      devise(:database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable)
    end

    # Makes the User 'approvable'
    # See https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
    def active_for_authentication?
      super && approved?
    end

    def inactive_message
      if !approved?
        :not_approved
      else
        super # Use whatever other message
      end
    end
  end
end
