xml = builder
hd_patient = Renalware::HD::PatientPresenter.new(patient)

xml.Encounters do
  hd_patient.finished_hd_sessions.each do |session|
    render "renalware/api/ukrdc/patients/encounters/hd_session",
           builder: xml,
           patient: patient,
           hd_patient: hd_patient,
           session: Renalware::HD::SessionPresenter.new(session)
  end
end
