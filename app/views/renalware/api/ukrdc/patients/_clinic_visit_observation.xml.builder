xml = builder

i18n_key ||= method
xml.Observation do
  xml.ObservationTime visit.datetime

  xml.ObservationCode do
    # xml.CodingStandard "2.16.840.1.113883.4.642.2.115"
    xml.CodingStandard "LOCAL"
    xml.Code I18n.t("loinc.#{i18n_key}.code")
    xml.Description I18n.t("loinc.#{i18n_key}.description")
  end

  xml.ObservationValue visit.public_send(method)
  xml.ObservationUnits I18n.t("loinc.#{i18n_key}.units")

  xml.Clinician do
    xml.Description visit.updated_by&.to_s
  end
end
