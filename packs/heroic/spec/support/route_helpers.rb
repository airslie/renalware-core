# frozen_string_literal: true

require Rails.root.join("spec/pages/page_object.rb")

module HeroicSystemHelpers
  def research
    Renalware::Research::Engine.routes.url_helpers
  end

  def click_on(locator = nil, ...)
    super
  rescue Capybara::ElementNotFound
    raise unless locator == "Save"

    super("Create", ...)
  end
end

Pages::PageObject.include(HeroicSystemHelpers)

RSpec.configure do |config|
  config.include HeroicSystemHelpers, type: :system
end
