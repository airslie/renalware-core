# frozen_string_literal: true

require_dependency "renalware/system"

module Renalware
  module System
    class ViewMetadataPolicy < BasePolicy
      def edit?
        user_is_super_admin?
      end

      def restore?
        edit?
      end
    end
  end
end
