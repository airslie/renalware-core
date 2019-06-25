# frozen_string_literal: true

#
# Things we are not going to include in RW2.0
# - PersonToContact
# - Occupation
# - ContactDetails - these may contain data not relating to the patient
#
xml = builder
path = "renalware/api/ukrdc/patients" # or "."

xml.Patient do
  xml.PatientNumbers do
    if patient.nhs_number.present?
      xml.PatientNumber do
        xml.Number patient.nhs_number
        xml.Organization "NHS"
        xml.NumberType "NI"
      end
    end

    Renalware.config.patient_hospital_identifiers.values.each do |field|
      next if (number = patient.public_send(field)).blank?

      xml.PatientNumber do
        xml.Number number
        xml.Organization "LOCALHOSP"
        xml.NumberType "MRN"
      end
      break
    end
  end

  xml.Names do
    render "#{path}/name", builder: xml, nameable: patient
  end

  xml.BirthTime patient.born_on.to_datetime

  if patient.dead? && patient.died_on.present?
    xml.DeathTime(patient.died_on.to_datetime)
  end

  xml.Gender patient.sex&.nhs_dictionary_number

  address = patient.current_address
  if address
    xml.Addresses do
      if address.present?
        render("#{path}/address", builder: xml, address: address)
      end
    end
  end

  xml.FamilyDoctor do
    if patient.practice.present?
      xml.GPPracticeId patient.practice.code
    end
    if patient.primary_care_physician.present?
      xml.GPId patient.primary_care_physician.code
    end
  end

  if patient.ethnicity.present?
    xml.EthnicGroup do
      xml.CodingStandard "NHS_DATA_DICTIONARY"
      xml.Code patient.ethnicity&.rr18_code
    end
  end

  # Omit 'Other' language as it is not part of the ISO set, but we have it for some reason
  if patient.language.present? && patient.language.code != "ot"
    xml.PrimaryLanguage do
      xml.CodingStandard "NHS_DATA_DICTIONARY_LANGUAGE_CODE" # ISO 639-1 plus braille and sign
      xml.Code patient.language&.code
      xml.Description patient.language
    end
  end

  if patient.dead?
    xml.Death true
  end

  # The CommonMetadata group
  xml.UpdatedOn patient.updated_at&.to_datetime
  xml.ActionCode "A" # A = added/updated. If we are posting this XML isn't only going to be 'A'?
  xml.ExternalId patient.ukrdc_external_id
end
