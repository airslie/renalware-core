FactoryGirl.define do
  factory :pd_regime_bag do
    bag_type
    volume 1
    per_week 3
    monday true
    tuesday false
    wednesday true
    thursday false
    friday true
    saturday false
    sunday false
  end
end
