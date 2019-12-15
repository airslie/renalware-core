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

    # Only take the first 20 characters, and then strip leading and trailing space.
    # This is to allow for rogue values like
    # '615                       615'
    xml.ObservationValue measurement.to_s[0, 19].strip
    xml.ObservationUnits I18n.t("loinc.#{i18n_key}.units")

    # xml.Clinician do
    #   xml.Description visit.updated_by&.to_s
    # end
  end
end
