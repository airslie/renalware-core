# frozen_string_literal: true

xml = builder

observation_times = {
  pre: session.performed_on + session.start_time.seconds_since_midnight.seconds,
  post: session.performed_on + session.end_time.seconds_since_midnight.seconds
}

{
  pre: session.document.observations_before,
  post: session.document.observations_after
}.each do |pre_post, observations|
  measurements = {
    "blood_pressure.systolic" => observations.blood_pressure&.systolic,
    "blood_pressure.diastolic" => observations.blood_pressure&.diastolic,
    "weight" => observations.weight
  }

  measurements.each do |i18n_key, value|
    if value.present? && value.to_f.nonzero?
      xml.Observation do
        xml.ObservationTime observation_times[pre_post].iso8601
        xml.ObservationCode do
          xml.CodingStandard "UKRR"
          xml.Code I18n.t("loinc.#{i18n_key}.code")
          xml.Description I18n.t("loinc.#{i18n_key}.description")
        end

        xml.ObservationValue value
        xml.ObservationUnits I18n.t("loinc.#{i18n_key}.units")
        xml.PrePost pre_post.to_s.upcase # eg PRE or POST
      end
    end
  end
end
