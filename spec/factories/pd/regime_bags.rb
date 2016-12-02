FactoryGirl.define do
  factory :pd_regime_bag, class: "Renalware::PD::RegimeBag" do
    bag_type
    volume 200
    per_week 3
    monday true
    tuesday false
    wednesday true
    thursday false
    friday true
    saturday false
    sunday false
    role :ordinary_bag
  end
end
