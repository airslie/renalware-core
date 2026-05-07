# frozen_string_literal: true


module Renalware
  module Heroic
    module Events
      class EventPolicy < Renalware::BasePolicy
        def destroy?
          user_is_super_admin?
        end
      end
    end
  end
end
