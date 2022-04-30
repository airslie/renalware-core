# frozen_string_literal: true

require "renalware/hd"

module Renalware
  module HD
    module Scheduling
      class ArchiveArguments
        attr_reader :from_week_period, :to_week_period, :up_until_date

        def initialize(from: nil, to: nil)
          @from_week_period = WeekPeriod.from_date(from || 1.year.ago)
          @up_until_date = (to || (Time.zone.now - 1.day)).to_date
          @to_week_period = WeekPeriod.from_date(@up_until_date)
        end
      end
    end
  end
end
