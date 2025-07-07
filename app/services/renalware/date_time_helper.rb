module Renalware
  class DateTimeHelper
    def self.merge(fields)
      if fields.first.is_a?(Date)
        date, time = fields
        return date if time.blank?

        DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec)
      else
        fields.compact.first
      end
    end
  end
end
