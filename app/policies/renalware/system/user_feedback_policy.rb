# frozen_string_literal: true

module Renalware
  module System
    class UserFeedbackPolicy < BasePolicy
      def index?
        user_is_super_admin?
      end
    end
  end
end
