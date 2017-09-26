xml = builder
patient = Renalware::HD::PatientPresenter.new(patient)

xml.Encounters do
  patient.finished_hd_sessions.each do |session|
    render "renalware/api/ukrdc/patients/encounters/hd_session",
           builder: xml,
           patient: patient,
           session: Renalware::HD::SessionPresenter.new(session)
  end
end
