# frozen_string_literal: true

module Renalware
  module Feeds
    module HL7Segments
      # SIU SCH segment
      class SCH < SimpleDelegator
        def starts_at = Time.zone.parse(timing_parts[3])
        def ends_at   = Time.zone.parse(timing_parts[4])
        def duration  = [appointment_duration, appointment_duration_units].compact_blank.join(" ")

        private

        def timing_parts = @timing_parts ||= appointment_timing_quantity.split("^")
      end
    end
  end
end
