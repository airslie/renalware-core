module PatientsHelper
  def modal_reasons_for(type)
    ModalityReason.where(:type => type)
  end

  def modal_change_options(selected = nil)
    options_for_select ["Other", ["Haemodialysis To PD", "HaemodialysisToPd"], ["PD To Haemodialysis", "PdToHaemodialysis"]], selected
  end

  def med_color_tag(med_type)
    med_type.blank? ? "drug" : med_type
  end

end
