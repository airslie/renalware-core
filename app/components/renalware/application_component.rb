# frozen_string_literal: true

module Renalware
  class ApplicationComponent < ActionView::Component::Base
    include Renalware::Engine.routes.url_helpers
  end
end