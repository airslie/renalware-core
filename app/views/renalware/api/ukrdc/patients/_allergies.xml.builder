# frozen_string_literal: true

#
# https://github.com/renalreg/ukrdc/blob/6d95e364dd8de857839fe6cdbd4e7fc3fb4c1d42/Schema/Allergies/Allergy.xsd
# This should be snomed-defined but we are just sending free text as that is all we have.
#
xml = builder

xml.Allergies do
  patient.allergies.includes(:updated_by).each do |allergy|
    xml.Allergy do
      xml.Allergy do
        xml.comment! "We don't have snomed code for allergies..?"
      end
      xml.Clinician do
        xml.Description allergy.updated_by&.to_s
      end
      xml.FreeTextAllergy allergy.description
    end
  end
end
