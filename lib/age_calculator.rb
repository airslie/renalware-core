# Borrowed from https://gist.github.com/amydoesntlai/74eb9aef1ea4b535f8fe

require "date"

class AgeCalculator
  # Calculates the an age based on the given current date.
  #
  # @param birth_date Date
  # @param current_date Date
  # @return [Hash] containing the year, month and day
  #
  def compute(birth_date, current_date)
    days   = current_date.day - birth_date.day
    months = current_date.month - birth_date.month
    years  = current_date.year - birth_date.year

    borrowed_month = false
    if days < 0
      # subtract month, get positive # for day
      days = Time.days_in_month(birth_date.month) - birth_date.day + current_date.day
      months -= 1
      borrowed_month = true
    end

    if months < 0
      # subtract year, get positive # for month
      months = 12 - birth_date.month + current_date.month
      months -= 1 if borrowed_month
      years -= 1
    end

    # Error-handling for future date
    if years < 0
      years = months = days = 0
    end

    { years: years, months: months, days: days }
  end
end
