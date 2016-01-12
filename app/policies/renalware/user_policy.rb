module Renalware
  class UserPolicy < BasePolicy
    def update?
      super && !user_update_self?
    end

    private

    def user_update_self?
      record == user
    end
  end
end