# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class Simple < Event
      validates :description, presence: true
    end
  end
end
