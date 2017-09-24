FactoryGirl.define do
  sequence :nhs_number do |n|
    n.to_s.rjust(10, "0000000000")
  end

  sequence :local_patient_id do |n|
    n.to_s.rjust(6, "Z99999")
  end

  factory :patient, class: "Renalware::Patient" do
    accountable
    nhs_number
    secure_id { SecureRandom.base58(24) }
    local_patient_id
    family_name "Jones"
    given_name "Jack"
    born_on "01/01/1988"
    paediatric_patient_indicator "0"
    sex "M"
    died_on nil
    first_cause_id nil

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryGirl's simple assoc method does not work
    #
    before(:create) do |patient|
      patient.build_current_address(attributes_for(:address))
    end

    trait :with_ethnicity do
      ethnicity factory: :ethnicity
    end
  end
end
