FactoryGirl.define do
  sequence :email do |n|
    "renalware.user-#{n}@nhs.net"
  end

  sequence :username do |n|
    "renalwareuser-#{n}"
  end

  factory :user do
    first_name 'Aneurin'
    last_name 'Bevan'
    username
    email
    password 'supersecret'
    approved false

    trait :approved do
      approved true
      after(:create) do |user|
        user.roles = [find_or_create_role]
      end
    end
    trait :expired do
      expired_at Time.zone.now
    end
    trait :super_admin do
      after(:create) do |user|
        user.roles = [find_or_create_role]
      end
    end
    trait :admin do
      after(:create) do |user|
        user.roles = [find_or_create_role(:admin)]
      end
    end
    trait :clinician do
      after(:create) do |user|
        user.roles = [find_or_create_role(:clinician)]
      end
    end
    trait :read_only do
      after(:create) do |user|
        user.roles = [find_or_create_role(:read_only)]
      end
    end
  end
end
