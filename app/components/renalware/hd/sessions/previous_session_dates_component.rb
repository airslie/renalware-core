# frozen_string_literal: true

module Renalware
  module HD
    module Sessions
      class PreviousSessionDatesComponent < ApplicationComponent
        attr_reader :patient

        def initialize(patient:)
          @patient = patient
        end

        def previous_sessions
          @previous_sessions ||= Session.where(patient: patient)
            .limit(3).order(started_at: :desc)
        end

        def render?
          previous_sessions.any?
        end
      end
    end
  end
end
