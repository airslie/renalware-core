# frozen_string_literal: true

require_dependency "renalware/admin"

module Renalware
  module Letters
    class PdfLetterCacheController < BaseController
      skip_after_action :verify_policy_scoped

      def destroy
        authorize [:renalware, :admin, :cache], :destroy?
        Renalware::Letters::PdfLetterCache.clear
        redirect_to admin_cache_path, notice: "Cache successfully cleared"
      end
    end
  end
end
