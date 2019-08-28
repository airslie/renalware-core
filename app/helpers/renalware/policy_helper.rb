# frozen_string_literal: true

module Renalware
  module PolicyHelper
    def pundit_policy_for(klass)
      Pundit.policy(
        current_user,
        klass.new
      )
    end
  end
end
