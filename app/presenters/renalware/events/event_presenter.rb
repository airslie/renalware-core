# frozen_string_literal: true

module Renalware
  module Events
    class EventPresenter < DumbDelegator
      include ::Renalware::AccountablePresentation
    end
  end
end
