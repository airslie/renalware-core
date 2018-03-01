# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Renalware::Concerns::CacheBusting
  protect_from_forgery with: :exception
  helper Renalware::Engine.helpers
end
