# frozen_string_literal: true

RSpec.configure do |config|
  config.after do
    travel_back
  end
end
