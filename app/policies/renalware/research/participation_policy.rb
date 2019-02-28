# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class ParticipationPolicy < ResearchPolicy
      def create?
        return if record.study.blank?

        user_is_an_investigator_in_this_study?
      end
      alias edit? create?
      alias new? create?
      alias destroy? create?

      private

      def user_is_an_investigator_in_this_study?
        record.study.investigatorships.pluck(:user_id).include?(user.id)
      end
    end
  end
end
