Given(/^there are drugs in the database$/) do
  %w(Red Blue Yellow Green Amoxicillin Cephradine Dicloxacillin Metronidazole Penicillin Rifampin Tobramycin Vancomycin).each do |name|
    instance_variable_set(:"@#{name.downcase}", FactoryGirl.create(:drug, :name => name))
  end
end

Given(/^there are drug types in the database$/) do
  %w(Antibiotic ESA Immunosuppressant Peritonitis).each do |dt|
    drug_type = FactoryGirl.create(:drug_type, code: dt.downcase, name: dt)
    instance_variable_set(:"@#{dt.downcase}", drug_type)
  end
end

Given(/^existing drugs have been assigned drug types$/) do
  @red.drug_types << @immunosuppressant
  @blue.drug_types << @esa
  @yellow.drug_types << @immunosuppressant
  @green.drug_types << @esa
  @amoxicillin.drug_types << @antibiotic
  @amoxicillin.drug_types << @peritonitis
  @cephradine.drug_types << @antibiotic
  @cephradine.drug_types << @peritonitis
  @dicloxacillin.drug_types << @antibiotic
  @dicloxacillin.drug_types << @peritonitis
  @metronidazole.drug_types << @antibiotic
  @metronidazole.drug_types << @peritonitis
  @penicillin.drug_types << @antibiotic
  @penicillin.drug_types << @peritonitis
  @rifampin.drug_types << @antibiotic
  @rifampin.drug_types << @peritonitis
  @tobramycin.drug_types << @antibiotic
  @tobramycin.drug_types << @peritonitis
  @vancomycin.drug_types << @antibiotic
  @vancomycin.drug_types << @peritonitis
end
