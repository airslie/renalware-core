module Renalware
  module System
    class UsersAwaitingApprovalComponent < ApplicationComponent
      attr_reader :current_user, :wrapper_classes

      def initialize(current_user:, wrapper_classes: "columns medium-6")
        @current_user = current_user
        @wrapper_classes = wrapper_classes
        super()
      end

      def users_needing_approval_count
        @users_needing_approval_count ||= User.unapproved.count
      end
    end
  end
end
