# frozen_string_literal: true

xml = builder

xml.Procedures do
  # HD Session procedures
  patient.finished_hd_sessions.each do |session|
    render "renalware/api/ukrdc/patients/procedures/dialysis_session",
           builder: xml,
           patient: patient,
           session: Renalware::HD::SessionPresenter.new(session)
  end

  # Transplant operation procedures
  patient.transplant_operations.each do |operation|
    render "renalware/api/ukrdc/patients/procedures/transplant_operation",
           builder: xml,
           patient: patient,
           operation: Renalware::UKRDC::TransplantOperationPresenter.new(operation)
  end
end
