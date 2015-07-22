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
    association :current_address, factory: :address
    doctor
    practice

    trait :with_problems do
      after(:create) do |patient|
        3.times { patient.problems << create(:problem) }
      end
    end
    trait :with_meds do
      after(:create) do |patient|
        3.times { patient.medications << create(:medication) }
      end
    end
    trait :with_clinics do
      after(:create) do |patient|
        3.times { |n| patient.clinics << create(:clinic, date: n.days.ago) }
      end
    end
  end
end
