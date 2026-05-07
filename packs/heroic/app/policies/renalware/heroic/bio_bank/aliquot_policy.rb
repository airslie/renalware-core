# frozen_string_literal: true


module Renalware
  module Heroic
    module BioBank
      class AliquotPolicy < ::Renalware::Research::ResearchPolicy
        def destroy?
          return true if user_is_super_admin? || user_is_a_manager_in_this_study?
          return true if aliquot_created_recently? && user_is_an_investigator_in_this_study?

          false
        end

        def create?
          user_is_super_admin? || user_is_an_investigator_in_this_study?
        end
        alias new? create?

        private

        def study
          Renalware::Heroic::Research::Study.first!
        end

        def aliquot_created_recently?
          record.created_at > Renalware::Heroic.config.new_aliquot_deletion_window.ago
        end
      end
    end
  end
end
