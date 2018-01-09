FactoryBot.define do
  sequence :email do |n|
    "renalware.user-#{n}@nhs.net"
  end

  sequence :username do |n|
    "renalwareuser-#{n}"
  end

  factory :user, class: "Renalware::User" do
    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    username
    email
    password "supersecret"
    approved true
    professional_position "Health Minister"
    signature { Faker::Name.name }

    # By default a user has no roles.
    # If you want a use with a role, use a trait, e.g. create(:user, :clinical)
    transient do
      role nil
    end

    after(:create) do |user, obj|
      if obj.role.present?
        user.roles << create(:role, obj.role)
      end
    end

    trait :unapproved do
      approved false
    end

    trait :author do
      signature { Faker::Name.name }
    end

    trait :expired do
      last_activity_at { 90.days.ago }
      expired_at { Time.zone.now }
    end

    trait :super_admin do
      transient do
        role :super_admin
      end
    end

    trait :admin do
      transient do
        role :admin
      end
    end

    trait :clinical do
      given_name "Aneurin"
      family_name "Bevan"
      signature "Aneurin Bevan"

      transient do
        role :clinical
      end
    end

    trait :read_only do
      transient do
        role :read_only
      end
    end
  end
end
