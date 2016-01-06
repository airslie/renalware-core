module Renalware
  class UserPolicy < BasePolicy
    def update?
      !user_updates_itself?
    end

    private

    def user_updates_itself?
      record.id == user.id
    end
  end
end