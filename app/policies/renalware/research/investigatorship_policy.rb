# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class InvestigatorshipPolicy < ResearchPolicy
      def destroy?
        return if record.study.blank?

        user_is_super_admin? || user_is_a_manager_in_this_study?
      end
      alias edit? destroy?
      alias new? destroy?
      alias create? destroy?
      alias update? destroy?
    end
  end
end
