# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module System
    class MockErrorsController < BaseController
      skip_after_action :verify_policy_scoped

      def index
        0 / 0 # ZeroDivisionError
      end
    end
  end
end
