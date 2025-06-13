module DateHelpers
  def todays_date
    l(Time.zone.today)
  end

  def todays_date_and_time
    l(Time.zone)
  end

  # A simple collection of dates so we don't have to make these up every time
  # and protects us from changes in date/time UI implementation; i.e. selecting
  # a different Calendar widget.
  def fake_date
    Date.parse("20-07-#{Date.current.year}")
  end

  def fake_time
    "10:45"
  end

  def fake_date_time
    "#{fake_date} #{fake_time}"
  end
end
