DRUGS = %w(Red Blue Yellow Green Amoxicillin Cephradine Dicloxacillin Metronidazole Penicillin Rifampin Tobramycin Vancomycin)
DRUG_TYPES = %w(Antibiotic ESA Immunosuppressant Peritonitis)


def load_drugs(*names)
  names.each do |name|
    instance_variable_set(:"@#{name.downcase}", create(:drug, :name => name))
  end
end

def load_all_drugs
  load_drugs(DRUGS)
end

def load_drug_types(*names)
  names.each do |dt|
    instance_variable_set(:"@#{dt.downcase}", create(:drug_type, :name => dt))
  end
end

def load_all_drug_types
  load_drug_types(DRUG_TYPES)
end

def set_drug_drug_types(drug,drug_type)
  create(:drug_drug_type, drug_id: drug.id, drug_type_id: drug_type.id)
end

# { 'Amoxicillin' => ['Antibiotic', 'Peritonitis'], 'Penicillin' => ['Foo', ...] }
def load_drugs_by_type(drugs_by_type)
  drugs_by_type.each do |drug_name, drug_type_names|

    drug = instance_variable_set(:"@#{drug_name.downcase}", create(:drug, name: drug_name))

    drug_type_names.each do |drug_type_name|
      unless drug_type = DrugType.find_by(name: drug_type_name)
        drug_type = instance_variable_set(:"@#{drug_type_name.downcase}",
          create(:drug_type, name: drug_type_name))
      end
      create(:drug_drug_type, drug_id: drug.id, drug_type_id: drug_type.id)
    end

  end
end

def load_med_routes
  @medication_routes = [["PO", "Per Oral"], ["IV", "Intravenous"], ["SC", "Subcutaneous"], ["IM", "Intramuscular"], ["Other", "Other (Refer to notes)"]]
  @medication_routes.map do |mr|
    instance_variable_set(:"@#{mr[0].downcase}", create(:medication_route, name: mr[0], full_name: mr[1]))
  end
end


