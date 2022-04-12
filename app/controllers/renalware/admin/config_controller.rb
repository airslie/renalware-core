# frozen_string_literal: true

require_dependency "renalware/admin"

module Renalware
  module Admin
    class ConfigController < BaseController
      def show
        authorize [:renalware, :admin, :config], :show?
        render :show, locals: { settings: displayable_settings }
      end

      private

      def displayable_settings
        (Renalware.config.methods - Object.methods)
          .flatten
          .reject { |name| name.to_s.include?("=") }
          .reject { |name| name == :config }
          .sort
      end
    end
  end
end
