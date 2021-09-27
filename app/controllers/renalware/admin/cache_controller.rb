# frozen_string_literal: true

require_dependency "renalware/admin"

module Renalware
  module Admin
    class CacheController < BaseController
      skip_after_action :verify_policy_scoped

      def show
        authorize [:renalware, :admin, :cache], :show?
      end

      def destroy
        authorize [:renalware, :admin, :cache], :destroy?
        Rails.cache.clear
        redirect_to admin_cache_path, notice: "Cache successfully cleared"
      end
    end
  end
end
