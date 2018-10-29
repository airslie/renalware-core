# frozen_string_literal: true

xml = builder

xml.Procedures do
  patient.finished_hd_sessions.each do |session|
    render "renalware/api/ukrdc/patients/procedures/dialysis_session",
           builder: xml,
           patient: patient,
           session: Renalware::HD::SessionPresenter.new(session)
  end
  # patient.prescriptions.each do |prescription|
  #   xml.Medication do
  #     xml.FromTime prescription.prescribed_on.to_datetime
  #     if prescription.terminated_or_marked_for_termination?
  #       xml.ToTime prescription.terminated_on&.to_datetime
  #     end
  #     xml.Route do
  #       xml.CodingStandard "RR22"
  #       xml.Code prescription.medication_route&.rr_code
  #       xml.Description prescription.medication_route&.name
  #     end
  #     xml.DrugProduct do
  #       xml.Generic prescription.drug
  #       # xml.Id do
  #       #   xml.CodingStandard "DM+D"
  #       #   xml.Code "dm + d code for the drug - coming soon"
  #       #   xml.Description prescription.drug
  #       # end
  #     end
  #     xml.Frequency prescription.frequency
  #     xml.Comments prescription.notes
  #     # xml.DoseUoM
  #     # xml.Indication
  #   end
  # end
end
