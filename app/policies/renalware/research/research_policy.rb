# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class ResearchPolicy < BasePolicy
      def create?
        user_is_admin? || user_is_super_admin?
      end
      alias edit? create?
      alias new? create?
      alias destroy? create?
    end
  end
end
