# frozen_string_literal: true

module Renalware
  module Letters
    module Mailshots
      class MailshotPolicy < BasePolicy
        def new?
          user_is_super_admin?
        end

        def create?
          new?
        end

        def index?
          user_is_super_admin? || user_is_admin?
        end
      end
    end
  end
end
