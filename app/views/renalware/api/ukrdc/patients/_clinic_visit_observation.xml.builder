# frozen_string_literal: true

measurement = visit.public_send(method)

if measurement.present? && measurement.to_f.nonzero?
  xml = builder
  i18n_key ||= method

  xml.Observation do
    xml.ObservationTime visit.datetime

    xml.ObservationCode do
      xml.CodingStandard "UKRR"
      xml.Code I18n.t("loinc.#{i18n_key}.code")
      xml.Description I18n.t("loinc.#{i18n_key}.description")
    end

    xml.ObservationValue measurement
    xml.ObservationUnits I18n.t("loinc.#{i18n_key}.units")

    xml.Clinician do
      xml.Description visit.updated_by&.to_s
    end
  end
end
