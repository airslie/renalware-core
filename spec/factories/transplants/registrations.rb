FactoryGirl.define do
  factory :transplant_registration, class: Renalware::Transplants::Registration do
    patient

    trait :with_statuses do
      after(:create) do |registration|
        10.downto(8).each do |day|
          start_date = day.days.ago
          create(:transplant_registration_status,
            registration: registration,
            started_on: start_date,
            terminated_on: start_date+1.day
          )
        end
        create(:transplant_registration_status,
          registration: registration,
          started_on: 7.day.ago
        )
      end
    end
  end
end
