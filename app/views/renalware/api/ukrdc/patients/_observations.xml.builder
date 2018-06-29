# frozen_string_literal: true

# What are observations in RW?
# - clinic visit
#   - weight
#   - bp
xml = builder

xml.Observations(
  start: patient.changes_since.to_date.iso8601,
  stop: patient.changes_up_until.to_date.iso8601
) do
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
