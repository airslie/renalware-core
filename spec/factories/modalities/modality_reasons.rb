FactoryGirl.define do
  sequence :rr_code do |n|
    200 + n
  end

  factory :modality_reason, class: "Renalware::Modalities::Reason" do
    rr_code
    description 'Patient / partner choice'
  end

  factory :pd_to_haemodialysis, parent: :modality_reason do
    type "Renalware::Modalities::PDToHaemodialysis"
    description 'Effective after temporary HD'
  end

  factory :haemodialysis_to_pd, parent: :modality_reason do
    type "Renalware::Modalities::HaemodialysisToPD"
    description 'Abdominal surgery or complications'
  end
end
