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
    calculation = OpenStruct.new(
      days:   current_date.day - birth_date.day,
      months: current_date.month - birth_date.month,
      years:  current_date.year - birth_date.year,
      borrowed_month: false
    )

    if calculation.days < 0
      days_in_month = Time.days_in_month(birth_date.month)
      calculation.days = days_in_month - birth_date.day + current_date.day
      calculation.months -= 1
      calculation.borrowed_month = true
    end

    if calculation.months < 0
      months_in_year = 12
      calculation.months = months_in_year - birth_date.month + current_date.month
      calculation.months -= 1 if calculation.borrowed_month
      calculation.years -= 1
    end

    # Error-handling for future date
    if calculation.years < 0
      calculation.years = calculation.months = calculation.days = 0
    end

    calculation.to_h.delete_if {|k,v| k == :borrowed_month}
  end
end
