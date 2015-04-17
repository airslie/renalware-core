FactoryGirl.define do
  factory :modality do
    patient
    modality_code
    modality_reason

    trait :pd_to_haemo do
      after(:create) do |instance|
        instance.modality_reason = create(:pd_to_haemodialysis)
      end
    end

    trait :haemo_to_pd_modality do
      after(:create) do |instance|
        instance.modality_reason = create(:haemodialysis_to_pd)
      end
    end
  end
end
