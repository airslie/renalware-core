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

      private

      def user_is_an_investigator_in_this_study?
        investigator_ids.pluck(:user_id).include?(user.id)
      end

      def user_is_a_manager_in_this_study?
        investigator_ids.where(manager: true).pluck(:user_id).include?(user.id)
      end

      def investigator_ids
        record.study.investigatorships
      end
    end
  end
end
