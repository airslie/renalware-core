# frozen_string_literal: true

module Renalware
  class WeekPeriod
    attr_reader :year, :week_number, :first_day_of_week

    def self.from_date(date)
      date = date.to_date
      new(week_number: date.cweek, year: date.year)
    end

    def initialize(week_number:, year:)
      @week_number = week_number.to_i
      @year = year.to_i
      validate_week_number
      validate_year
      @first_day_of_week = Date.commercial(@year, @week_number)
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

    def to_s
      "#{I18n.l(first_day_of_week, format: :long)} to #{I18n.l(last_day_of_week, format: :long)}"
    end

    # The date of last day of the week (a Sunday)
    def last_day_of_week
      @last_day_of_week ||= (first_day_of_week + 1.week - 1.minute).to_date
    end

    def validate_week_number
      if week_number < 1 || week_number > 53
        raise(ArgumentError, "invalid date: week_number must be 1-53")
      end
    end

    def validate_year
      if year <= 2000
        raise(ArgumentError, "invalid date year must be >= 2000")
      end
    end

    def to_h
      {
        year: year,
        week_number: week_number
      }
    end
  end
end
