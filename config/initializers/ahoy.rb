# frozen_string_literal: true

class Ahoy::Store < Ahoy::DatabaseStore
  def visit_model
    Renalware::System::Visit
  end

  def event_model
    Renalware::System::Event
  end
end

# set to true for JavaScript tracking
Ahoy.api = false
Ahoy.visit_duration = 30.minutes
Ahoy.geocode = false
Ahoy.exclude_method = ->(_controller, _request) { ENV["SKIP_AHOY"] }
