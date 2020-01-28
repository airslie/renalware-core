# frozen_string_literal: true

module Renalware
  class ApplicationComponent < ActionView::Component::Base
    include Renalware::Engine.routes.url_helpers
    include Pundit::Helper

    # Not sure why include Renalware::Engine.routes.url_helpers does not make the 
    # engine urls visible in the views (seems to resolve alwatys to /assets?..) 
    # so we expose routes here so inside a component html file we can use 
    # e.g. renalware.bookmarks_path 
    def renalware
      Renalware::Engine.routes.url_helpers
    end
  end
end