# frozen_string_literal: true

require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class DescriptionPolicy < BasePolicy
      def index?
        user_is_super_admin?
      end
      alias new? index?
      alias create? index?
      alias sort? index?

      def edit?
        return false if record.deleted?

        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
