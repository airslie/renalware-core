# What are observations in RW?
# - clinic visit
#   - weight
#   - bp
xml = builder

xml.Observations(start: Time.zone.today.iso8601, stop: Time.zone.today.iso8601) do
  xml.comment! "Check what start and stop refer to here"
  patient.clinic_visits.each do |visit|
    render "clinic_visit_observation",
           visit: visit,
           method: :systolic_bp,
           i18n_key: "blood_pressure.systolic"

    render "clinic_visit_observation",
           visit: visit,
           method: :diastolic_bp,
           i18n_key: "blood_pressure.diastolic"

    render "clinic_visit_observation",
           visit: visit,
           method: :weight
  end
end
