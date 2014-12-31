module PatientsHelper
  def modal_reasons_for(type)
    ModalityReason.where(:type => type)
  end

  def modal_change_options(selected = nil)
    options_for_select ["Other", ["Haemodialysis To PD", "HaemodialysisToPd"], ["PD To Haemodialysis", "PdToHaemodialysis"]], selected
  end

end
