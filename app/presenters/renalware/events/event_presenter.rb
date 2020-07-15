# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class EventPresenter < DumbDelegator
      include ::Renalware::AccountablePresentation
    end
  end
end
