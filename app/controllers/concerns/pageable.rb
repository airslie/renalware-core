require 'active_support/concern'

module Pageable
  extend ActiveSupport::Concern

  included do
    def prepare_paging
      @page = params[:page]
      @per_page = params[:per_page]
    end
  end
end
