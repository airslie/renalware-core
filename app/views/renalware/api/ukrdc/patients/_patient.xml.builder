xml = builder

xml.Patient do
    xml.PatientNumbers do
      xml.PatientNumber do
        xml.Number patient.nhs_number
        xml.Organization "NHS"
      end
      Renalware.config.patient_hospital_identifiers.values.each do |field|
        next if (number = patient.public_send(field)).blank?
        xml.PatientNumber do
          xml.Number number
          xml.Organization "LOCALHOSP"
        end
      end
    end

    xml.Names do
      render "name", builder: xml, nameable: patient
    end

    xml.BirthTime patient.born_on.to_datetime
    xml.DeathTime(patient.died_on.to_datetime) if patient.died_on?
    # TODO: 0=Not Known 1=Male 2=Female 9=Not Specified.
    xml.Gender patient.sex&.nhs_dictionary_number

    xml.CountryOfBirth "???"

    xml.FamilyDoctor do
      xml.GPPracticeId
      xml.GPId
    end

    xml.PersonToContact do
      xml.Name
      xml.ContactDetails do
        xml.Value
        xml.Comments
      end
      xml.Relationship
    end

    if patient.ethnicity.present?
      xml.EthnicGroup do
        xml.CodingStandard "NHS_DATA_DICTIONARY"
        xml.Code patient.ethnicity&.rr18_code
      end
    end

    xml.Occupation do
    end

    xml.PrimaryLanguage do
    end

    if patient.current_modality == :death
      xml.Death do
      end
    end

    address = patient.current_address
    if address
      xml.Addresses do
        render("address", builder: xml, address: address) unless address.blank?
      end
    end

    # CommonMetadata group
    xml.UpdatedOn patient.updated_at.to_datetime
    xml.ActionCode
    xml.ExternalId
  end
