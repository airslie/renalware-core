# frozen_string_literal: true

module Renalware
  module Pathology
    class CodeGroupPolicy < BasePolicy
      def create?
        user_is_super_admin?
      end

      def update?
        create?
      end

      def destroy?
        create?
      end

      def edit?
        create?
      end
    end
  end
end
