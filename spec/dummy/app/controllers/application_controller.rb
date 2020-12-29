# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Renalware::Concerns::CacheBusting
  protect_from_forgery with: :exception
  helper Renalware::Engine.helpers

  before_action :set_locale

  private

  # rubocop:disable Style/ConditionalAssignment
  def set_locale
    if user_signed_in?
      I18n.locale = current_user.language.presence || ENV["DEFAULT_LANG"] || I18n.default_locale
    else
      # DEFAULT_LANG for testing on Heroku - forcing to pt for instance
      I18n.locale = ENV["DEFAULT_LANG"] || params[:lang] || I18n.default_locale
    end
  end
  # rubocop:enable Style/ConditionalAssignment

  def locale_from_header
    request.env.fetch("HTTP_ACCEPT_LANGUAGE", "").scan(/[a-z]{2}/).first
  end
end
