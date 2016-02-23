FactoryGirl.define do
  factory :access_profile, class: Renalware::Accesses::Profile do
    patient
    type { create(:access_type) }
    site { create(:access_site) }
    side :right
    formed_on { Time.zone.today }
    association :created_by,  factory: :user
    association :updated_by,  factory: :user

    trait :current do
      started_on { 1.day.ago }
    end
  end
end
