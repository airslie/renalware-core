# frozen_string_literal: true

# Filters sensitive data from exception messages. In some exception messages, such
# as routing errors, Rails will include the object it attempted to create a route with,
# exposing records from the database. This middleware reporter using PartyFoul filters
# the messages before reporting.
#
module ExceptionNotification
  class Middleware < PartyFoul::Middleware
    def initialize(app)
      @app = app
    end

    # rubocop:disable Lint/RescueException
    def call(env)
      @app.call(env)
    rescue Exception => captured_exception
      if allow_handling?(captured_exception)
        PartyFoul::ExceptionHandler.handle(FilteredException.new(captured_exception), env)
      end
      raise captured_exception
    end
    # rubocop:enable Lint/RescueException
  end
end
