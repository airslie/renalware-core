# frozen_string_literal: true

require "rails_helper"

module Pages
  class PageObject
    include Capybara::DSL
    include Renalware::Engine.routes.url_helpers
  end
end
