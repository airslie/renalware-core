# frozen_string_literal: true

require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class DescriptionPolicy < BasePolicy
      def index?
        user_is_any_admin?
      end
      alias show? index?

      def new?
        user_is_super_admin?
      end
      alias create? new?
      alias sort? new?

      def edit?
        return false if record.deleted?

        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
