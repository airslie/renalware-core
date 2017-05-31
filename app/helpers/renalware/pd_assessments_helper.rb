module Renalware
  module PDAssessmentsHelper

    def delivery_interval_options
      PD::Assessment::VALID_RANGES.delivery_intervals.map do |interval|
        [pluralize(interval, "week"), interval]
      end
    end

  end
end
