# frozen_string_literal: true

xml = builder

xml.Encounters do
  patient.modalities.each do |session|
    render "renalware/api/ukrdc/patients/encounters/treatment",
           builder: xml,
           patient: patient,
           session: Renalware::HD::SessionPresenter.new(session)
  end
end
