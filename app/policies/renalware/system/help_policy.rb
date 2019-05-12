# frozen_string_literal: true

require_dependency "renalware/snippets"

module Renalware
  module System
    class HelpPolicy < BasePolicy
      def new?
        user_is_super_admin?
      end

      def create?
        user_is_super_admin?
      end

      def destroy?
        user_is_super_admin?
      end
    end
  end
end
