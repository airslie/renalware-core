# Borrowed from https://gist.github.com/amydoesntlai/74eb9aef1ea4b535f8fe

require "date"

DAYS_IN_MONTH  = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

# This method returns the person's age based on the given current date.
# The age is in number of years, month and days (hash).
def birthday_age(birth_date, current_date)
  borrowed_month = false

  # Get days for this year
  if current_date.to_date.leap?
    DAYS_IN_MONTH[2] = 29
  end

  days   = current_date.day - birth_date.day
  months = current_date.month - birth_date.month
  years  = current_date.year - birth_date.year

  if days < 0
    # subtract month, get positive # for day
    days = DAYS_IN_MONTH[birth_date.month] - birth_date.day + current_date.day
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