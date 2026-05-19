# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class UsagePolicy < ::Renalware::Research::ResearchPolicy
        def edit?
          return true if user_is_super_admin? || user_is_a_manager_in_this_study?
          return true if created_recently? && user_is_an_investigator_in_this_study?

          false
        end
        alias update? edit?

        def new?
          user_is_super_admin? || user_is_an_investigator_in_this_study?
        end
        alias create? new?

        private

        def study
          Renalware::Heroic::Research::Study.first!
        end

        def created_recently?
          record.created_at > Renalware::Heroic.config.new_aliquot_usage_edit_window.ago
        end
      end
    end
  end
end
