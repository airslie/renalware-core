FactoryGirl.define do
  sequence :email do |n|
    "renalware.user-#{n}@nhs.net"
  end

  sequence :username do |n|
    "renalwareuser-#{n}"
  end

  factory :user, class: "Renalware::User" do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username
    email
    password 'supersecret'
    approved false
    professional_position 'Health Minister'

    trait :author do
      signature { Faker::Name.name }
    end

    trait :approved do
      approved true
      after(:create) do |user|
        user.roles = [find_or_create_role]
      end
    end
    trait :expired do
      last_activity_at 60.days.ago
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
      first_name "Aneurin"
      last_name "Bevan"
      signature "Aneurin Bevan"

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
