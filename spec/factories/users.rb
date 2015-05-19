FactoryGirl.define do
  sequence :email do |n|
    "renalware.user-#{n}@nhs.net"
  end

  sequence :username do |n|
    "renalwareuser-#{n}"
  end

  factory :user do
    username
    email
    password 'supersecret'

    trait :approved do
      approved true
    end
    trait :super_admin do
      after(:create) do |user|
        user.roles = [create(:role)]
      end
    end
    trait :admin do
      after(:create) do |user|
        user.roles = [create(:role, :admin)]
      end
    end
    trait :clinician do
      after(:create) do |user|
        user.roles = [create(:role, :clinician)]
      end
    end
  end
end
