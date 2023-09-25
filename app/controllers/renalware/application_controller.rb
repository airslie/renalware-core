# frozen_string_literal: true

module Renalware
  # Note that we inherit from ::ApplicationController which is defined in the host application.
  # This allows application to
  # - define the default layout
  # - intercept requests with before_action etc.
  class ApplicationController < ::ApplicationController
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :reset_session

    # See https://github.com/hotwired/turbo-rails/pull/367#issuecomment-1601733561
    # Awaiting a better way to redirect out of form in a modal inside a turbo_frame_tag when
    # posting/putting to a controller and the result is a success.
    # Without this helper (called from the controller), the normal
    # redirect_to from the controller does not work, ie you currently need to render a turbo
    # stream with js that does the redirect. Not a great experience. Keeping an eye out for
    # a fix.
    def turbo_visit(url, frame: nil, action: nil)
      options = { frame: frame, action: action }.compact
      turbo_stream.append_all("head") do
        helpers.javascript_tag(<<~SCRIPT.strip, nonce: true, data: { turbo_cache: false })
          window.Turbo.visit("#{helpers.escape_javascript(url)}", #{options.to_json})
          document.currentScript.remove()
        SCRIPT
      end
    end
  end
end
