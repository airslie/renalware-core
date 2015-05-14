FactoryGirl.define do
  sequence :email do |n|
    "renalware.user-#{n}@nhs.net"
  end

  factory :user do
    email
    password 'supersecret'
    trait :approved do
      approved true
    end
  end
end
