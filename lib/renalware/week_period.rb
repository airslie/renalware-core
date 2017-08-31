module Renalware
  class WeekPeriod
    attr_reader :week_number, :year

    def self.from_date(date)
      date = date.to_date
      new(date.cweek, date.year)
    end

    def initialize(week_number, year)
      @week_number = week_number
      @year = year
    end

    # The date of first day of the week (a Monday)
    def start
      @start ||= Date.commercial(year, week_number)
    end

    # The date of last day of the week (a Sunday)
    def finish
      @finish ||= (start + 1.week - 1.minute).to_date
    end
  end
end
