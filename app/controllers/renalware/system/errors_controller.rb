module Renalware
  module System
    class ErrorsController < ApplicationController
      layout "renalware/layouts/error"

      def not_found
        render status: 404, formats: [:html]
      end

      def internal_server_error
        render status: 500, formats: [:html]
      end

      def generate_test_internal_server_error
        raise "This is an intentionally raised error - please ignore it. " \
              "It is used only to test system integration"
      end
    end
  end
end
