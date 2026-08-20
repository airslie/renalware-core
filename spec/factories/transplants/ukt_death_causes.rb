FactoryBot.define do
  factory :transplant_ukt_death_cause, class: "Renalware::Transplants::UKTDeathCause" do
    sequence(:code) { |n| "cause_#{n}" }
    sequence(:name) { |n| "Cause #{n}" }
    sequence(:position)
    enabled { true }
  end
end
