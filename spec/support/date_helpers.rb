# frozen_string_literal: true

module DateHelpers
  def todays_date
    I18n.l(Time.zone.today)
  end

  def todays_date_and_time
    I18n.l(Time.zone)
  end
end
