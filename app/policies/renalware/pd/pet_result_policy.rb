# frozen_string_literal: true

module Renalware
  module PD
    class PETResultPolicy < BasePolicy
      def destroy?
        user_is_admin? || user_is_super_admin?
      end

      def edit?
        destroy?
      end
    end
  end
end
