# frozen_string_literal: true

module Renalware
  module System
    class NagDefinitionPolicy < BasePolicy
      def new?
        user_is_super_admin?
      end

      def create?
        new?
      end

      def edit?
        new?
      end

      def update?
        create?
      end

      def index?
        user_is_super_admin? || user_is_admin?
      end
    end
  end
end
