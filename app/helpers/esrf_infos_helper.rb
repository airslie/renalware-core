module EsrfInfosHelper
  def display_prd_date(patient)
    patient.try(:esrf_info).try(:date)
  end

  def display_prd(patient)
    patient.try(:esrf_info).try(:prd_code).try(:term)
  end
end
