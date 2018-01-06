module Renalware
  class Devise::SessionsController < ::Devise::SessionsController
    include Concerns::DeviseControllerMethods

    layout "renalware/layouts/application"

    # Define the path to go to after logging in:
    # - if the user has never before logged-in, devise will take them to the root path (dashboard)
    # - if the user's session timed-out less that 30 minutes ago, we take them back to the
    #    last page they were on.
    # - if the user's session timed-out more than 30 minutes ago, we take them back to the
    #    their dashboard. See PR #1592 for rationale.
    # - if the user has explicitly logged-out they will always go the the dashboard path on login,
    #   regardless of how long ago they signed out, because in this instance devise removes it's
    #   entries in the session cookie.
    def after_sign_in_path_for(resource)
      max_duration_of_url_memory = Renalware.config.duration_of_last_url_memory_after_session_expiry
      max_duration_has_passed = last_sign_in_at <= max_duration_of_url_memory.ago
      max_duration_has_passed ? dashboard_path : super
    end

    # Important note: Since Devise 4.4.0 the gem's SessionsController#create will do an implicit
    # check to see if the resource (User signing-in) is valid. If the user is not valid it now
    # skips the redirect to the path specified in .after_sign_in_path_for.
    # The result for us was that the user _could_ log on, but they stayed on the login screen
    # (the appearance of the menu indicated they were in fact logged in). The redirect was not
    # happening because the user was invalid (ie there were validation errors and
    # user.valid? == false).
    # The reason for the validation errors is that we have some conditional validation in User;
    # for instance only validate #signature during an update, not on
    # a create - after all #signature is something they set up later in their 'profile'.
    # So what we have to do here is stop Devise from thinking the user in invalid by skipping
    # validations.
    # See https://github.com/plataformatec/devise/issues/4742#issuecomment-355154023
    # Note that ideally we should move signature, professional position etc to a Profile model
    # and then we could remove the conditional validation.
    def create
      super { |resource| resource.skip_validation = true }
    end

    private

    def last_sign_in_at
      current_user.last_sign_in_at || epoch_start
    end

    def epoch_start
      Date.new(0)
    end
  end
end
