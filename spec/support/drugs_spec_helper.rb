def load_drugs
  %w(Red Blue Yellow Green Amoxicillin Cephradine Dicloxacillin Metronidazole Penicillin Rifampin Tobramycin Vancomycin).each do |name|
    instance_variable_set(:"@#{name.downcase}", FactoryGirl.create(:drug, :name => name))
  end
end

def load_drug_types
  %w(Antibiotic ESA Immunosuppressant Peritonitis).each do |dt|
    instance_variable_set(:"@#{dt.downcase}", FactoryGirl.create(:drug_type, :name => dt))
  end
end

def load_med_routes
  @medication_routes = [["PO", "Per Oral"], ["IV", "Intravenous"], ["SC", "Subcutaneous"], ["IM", "Intramuscular"], ["Other", "Other (Refer to notes)"]]
  @medication_routes.map do |mr|
    instance_variable_set(:"@#{mr[0].downcase}", FactoryGirl.create(:medication_route, name: mr[0], full_name: mr[1]))
  end
end

def set_drug_drug_types
  FactoryGirl.create(:drug_drug_type, drug_id: @amoxicillin.id, drug_type_id: @antibiotic.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @amoxicillin.id, drug_type_id: @peritonitis.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @penicillin.id, drug_type_id: @antibiotic.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @penicillin.id, drug_type_id: @peritonitis.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @cephradine.id, drug_type_id: @antibiotic.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @cephradine.id, drug_type_id: @peritonitis.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @dicloxacillin.id, drug_type_id: @antibiotic.id)
  FactoryGirl.create(:drug_drug_type, drug_id: @dicloxacillin.id, drug_type_id: @peritonitis.id)
end


