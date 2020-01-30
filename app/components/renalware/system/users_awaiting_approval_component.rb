# frozen_string_literal: true

module Renalware
  module System
    class UsersAwaitingApprovalComponent < ApplicationComponent
      attr_reader :current_user

      def initialize(current_user:)
        @current_user = current_user
      end

      def users_needing_approval_count
        @users_needing_approval_count ||= User.unapproved.count
      end

      def users_needing_approval_title
        [
          users_needing_approval_count,
          "user".pluralize(users_needing_approval_count),
          "awaiting approval"
        ].join(" ")
      end
    end
  end
end
