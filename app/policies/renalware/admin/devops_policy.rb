# frozen_string_literal: true

require_dependency "renalware/admin"

module Renalware
  module Admin
    class DevopsPolicy < BasePolicy
      def show?
        user_is_devops? || user_is_super_admin?
      end
      alias index? show?
      alias edit? show?
      alias update? show?
      alias destroy? show?
      alias new? show?
    end
  end
end
