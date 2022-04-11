# frozen_string_literal: true

require_dependency "renalware/admin"

module Renalware
  module Admin
    class ConfigPolicy < BasePolicy
      def show?
        user_is_super_admin?
      end

      def update?
        false
      end
      alias edit? update?
      alias create? update?
      alias destroy? update?
    end
  end
end
