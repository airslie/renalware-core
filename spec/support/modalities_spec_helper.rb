MODALITIES = [
  ["death","Death"],
  ["diabetic","Renal/Diabetic"],
  ["filtration", "Filtration"],
  ["lowclear", "Low Clearance"],
  ["PD_APD", "PD-APD"],
  ["PD_CAPD", "PD-CAPD"],
  ["PD_rest_HD", "PD Rest on HD"],
  ["PD_assistedAPD", "PD-Assisted APD"],
  ["livedonor", "Live Donor"],
  ["PD_assistedAPD", "PD-Assisted APD"],
  ["PD_prePD", "PD-PrePD"],
  ["heartfailure", "Heart Failure"]
]

def load_modalities(*modalities)
  modalities.each do |modality|
    instance_variable_set(:"@#{modality[0].downcase}", create(:modality_description, code: modality[0], name: modality[1]))
  end
end

def load_all_modalities
  load_modalities(MODALITIES)
end
