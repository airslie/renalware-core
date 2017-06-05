FactoryGirl.define do
  factory :dry_weight, class: "Renalware::Clinical::DryWeight" do
    #patient

    assessed_on 1.week.ago
    weight 156.1
    association :assessor, factory: :user
    association :created_by,  factory: :user
    association :updated_by,  factory: :user
  end
end
