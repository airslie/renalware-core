FactoryBot.define do
  factory :hd_anticoagulant, class: "Renalware::HD::Anticoagulant" do
    sequence(:code) { |n| "anticoagulant_#{n}" }
    name { "Anticoagulant" }
  end
end
