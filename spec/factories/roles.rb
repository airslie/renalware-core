FactoryGirl.define do
  factory :role do
    name :super_admin

    trait :admin do
      name :admin
    end
    trait :clinician do
      name :clinician
    end
  end
end
