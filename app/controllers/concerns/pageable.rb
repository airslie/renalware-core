require 'active_support/concern'

module Pageable
  extend ActiveSupport::Concern

  included do
    def prepare_paging
      if params[:q].present?
        @page = params[:q][:page]
        @per_page = params[:q][:per_page]
      end
    end
  end
end
