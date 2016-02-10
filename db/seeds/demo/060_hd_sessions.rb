module Renalware
  log '--------------------Add fake HD sessions-------------------'
  units = Hospitals::Unit.hd_sites.limit(3).to_a
  users = User.limit(3).to_a
  patients = Patient.limit(10).to_a
  start_times = ["13:00", "13:15", "13:30"]
  end_times = ["15:30", "15:45", "16:00"]
  dates = (1..30).to_a
  50.times do |i|
    session = HD::Session.create!(
      patient: patients.sample,
      hospital_unit: units.sample,
      performed_on: dates.sample.days.ago,
      start_time: start_times.sample,
      end_time: end_times.sample,
      signed_on_by: users.sample,
      signed_off_by: users.sample,
      by: users.sample
    )
  end

  20.times do |i|
    session = HD::Session.create!(
      patient: patients.sample,
      hospital_unit: units.sample,
      performed_on: dates.sample.days.ago,
      start_time: start_times.sample,
      signed_on_by: users.sample,
      by: users.sample
    )
  end
end