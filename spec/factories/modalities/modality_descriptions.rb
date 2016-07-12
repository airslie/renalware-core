FactoryGirl.define do
  factory :modality_description, class: "Renalware::Modalities::Description" do
    name 'CAPD (disconnect)'

    trait :capd_standard do
      name 'CAPD (standard)'
    end
    trait :ccpd_6_nights do
      name 'CCPD (<6 nights/wk)'
    end
  end
end
