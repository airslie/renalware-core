# frozen_string_literal: true

# require "rails_helper"

module Pages
  class PageObject
    include Capybara::DSL
    include RSpec::Matchers
    include Renalware::Engine.routes.url_helpers
    include ActionView::Helpers::TranslationHelper
    include FormHelpers
  end
end
