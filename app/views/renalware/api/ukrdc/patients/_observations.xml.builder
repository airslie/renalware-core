# What are observations in RW?
# - clinic visit
#   - weight
#   - bp
xml = builder

# TODO: Implement start stop dates
# xml.Observations do(start: Time.zone.today.iso8601, stop: Time.zone.today.iso8601) do
xml.Observations do
  patient.clinic_visits.each do |visit|
    render "clinic_visit_observation",
           visit: visit,
           method: :systolic_bp,
           i18n_key: "blood_pressure.systolic",
           builder: builder

    render "clinic_visit_observation",
           visit: visit,
           method: :diastolic_bp,
           i18n_key: "blood_pressure.diastolic",
           builder: builder

    render "clinic_visit_observation",
           visit: visit,
           method: :weight,
           i18n_key: "weight",
           builder: builder

    render "clinic_visit_observation",
           visit: visit,
           method: :height,
           i18n_key: "height",
           builder: builder
  end
end
