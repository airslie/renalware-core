# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class SamplePolicy < ::Renalware::Research::ResearchPolicy
        def destroy?
          user_is_super_admin? || user_is_a_manager_in_this_study?
        end

        def edit?
          user_is_super_admin? || user_is_an_investigator_in_this_study?
        end
        alias update? edit?
        alias new? edit?
        alias create? edit?

        private

        def study
          Renalware::Heroic::Research::Study.first!
        end
      end
    end
  end
end
