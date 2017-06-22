#
# https://github.com/renalreg/ukrdc/blob/6d95e364dd8de857839fe6cdbd4e7fc3fb4c1d42/Schema/Allergies/Allergy.xsd
# This should be snomed-defined but we are just sending free text as that is all we have.
#
xml = builder

xml.Allergies do
  patient.allergies.each do |allergy|
    xml.Allergy do
      xml.Clinician allergy.updated_by&.to_s
      xml.FreeTextAllergy allergy.description
    end
  end
end
