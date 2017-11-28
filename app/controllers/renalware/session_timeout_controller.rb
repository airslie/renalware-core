# This controller exposes a has_user_timed_out action which is invoked via Ajax on a JavaScript
# timer and will cause the user to be redirected to the login page if their session has expired
# due to a period of activity. The redirect happens because of a generic Ajax error handling
# JavaScript - see ajax_errors.js - which causes the page to reload after any Ajax 401 error
# thus causing a redirect to the login page in the usual Rails way (i.e. as if the user had tried
# to refresh the page or attempt some action after devise had logged them out on the server).
#
# Inspired by this SO post: https://stackoverflow.com/questions/17791626
#
module Renalware
  class SessionTimeoutController < BaseController
    prepend_before_action :skip_timeout, only: :has_user_timed_out
    skip_before_action :authenticate_user!, only: :has_user_timed_out

    # Note this action will NOT update the session activity (thus keeping the session alive)
    # because we invoke #skip_timeout at the beginning of the filter chain.
    # We could return the amount of time remaining before the session expires like so
    #   time_left = Devise.timeout_in - (Time.now - user_session["last_request_at"]).round
    # and display this to the user if required.
    # rubocop :disable Naming/PredicateName
    def has_user_timed_out
      skip_authorization
      if referrer_is_a_devise_url? || !current_users_session_has_timed_out?
        head(:ok)
      else
        flash[:notice] = "Your session timed due to inactivity. Please log in again."
        head :unauthorized
      end
    end
    # rubocop :enable Naming/PredicateName

    # A user could invoke this action to keep their session alive, by for example
    # clicking on a "Keep my session active" button which makes an ajax call to this action.
    # Note this will keep the session alive because we have not invoked skip_timeout before
    # action, so, like all actions on all controllers, the user's last_request_at time stamp is
    # updated in their session cookie.
    def reset_user_clock
      head :ok
    end

    private

    def skip_timeout
      request.env["devise.skip_trackable"] = true
    end

    def current_users_session_has_timed_out?
      return true if user_session.blank?
      last_request_at = Time.zone.at(user_session["last_request_at"])
      !current_user || current_user.timedout?(last_request_at)
    end

    # Returns a truthy value if we came from a devise URL like users/sign_in
    def referrer_is_a_devise_url?
      referrer = request.referer
      return if request.blank?
      regex_defining_devise_paths = %r{(#{new_user_session_path}|users\/password|users\/sign_up)}
      URI.parse(referrer).path =~ regex_defining_devise_paths
    end
  end
end
