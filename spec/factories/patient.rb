FactoryGirl.define do
  sequence :nhs_number do |n|
    n.to_s.rjust(10, '1234567890')
  end

  sequence :local_patient_id do |n|
    n.to_s.rjust(6, 'Z99999')
  end

  factory :patient do
    nhs_number
    local_patient_id
    surname "Jones"
    forename "Jack"
    birth_date "01/01/1988"
    paediatric_patient_indicator "0"
    sex 1
    ethnicity_id 1
    death_date nil
    first_edta_code_id nil
  end
end
