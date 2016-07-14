FactoryGirl.define do
  sequence :nhs_number do |n|
    n.to_s.rjust(10, '1234567890')
  end

  sequence :local_patient_id do |n|
    n.to_s.rjust(6, 'Z99999')
  end

  factory :patient, class: "Renalware::Patient" do
    nhs_number
    local_patient_id
    family_name "Jones"
    given_name "Jack"
    born_on "01/01/1988"
    paediatric_patient_indicator "0"
    sex "M"
    ethnicity
    died_on nil
    first_edta_code_id nil
    association :created_by, factory: :user
    association :updated_by, factory: :user

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryGirl's simple assoc method does not work
    #
    before(:create) do |patient|
      patient.build_current_address(attributes_for(:address))
    end

    trait :with_problems do
      after(:create) do |patient|
        3.times { create(:problem, patient: patient) }
      end
    end
    trait :with_meds do
      after(:create) do |patient|
        3.times { patient.medications << create(:medication, by: patient.created_by) }
      end
    end
    trait :with_clinic_visits do
      after(:create) do |patient|
        3.times { |n| create(:clinic_visit, patient: patient, date: n.days.ago) }
      end
    end
  end
end
