module Renalware
  class WeekPeriod
    attr_reader :week_number, :year, :first_day_of_week

    def self.from_date(date)
      date = date.to_date
      new(date.cweek, date.year)
    end

    def initialize(week_number, year)
      @week_number = week_number
      @year = year
      validate_week_number
      validate_year
      @first_day_of_week = Date.commercial(year, week_number)
    end

    def next
      self.class.from_date(first_day_of_week + 1.week)
    end

    def previous
      self.class.from_date(first_day_of_week - 1.week)
    end

    def to_a
      [week_number, year]
    end

    # The date of last day of the week (a Sunday)
    def last_day_of_week
      @last_day_of_week ||= (first_day_of_week + 1.week - 1.minute).to_date
    end

    def validate_week_number
      if week_number.blank? || week_number < 1 || week_number > 53
        raise(ArgumentError, "invalid date: week_number must be 1-53")
      end
    end

    def validate_year
      if year.blank? || year <= 2000
        raise(ArgumentError, "invalid date year must be >= 2000")
      end
    end
  end
end
