FactoryGirl.define do
  factory :hd_dry_weight, class: "Renalware::HD::DryWeight" do
    patient

    assessed_on 1.week.ago
    weight  156
    association :assessor, factory: :user
    association :created_by,  factory: :user
    association :updated_by,  factory: :user
  end
end
