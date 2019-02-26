# frozen_string_literal: true

module Renalware
  module System
    class EmailTemplatesController < BaseController
      skip_after_action :verify_authorized
      skip_after_action :verify_policy_scoped

      def index
        render
      end
    end
  end
end
