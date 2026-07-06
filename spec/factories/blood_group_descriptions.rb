FactoryBot.define do
  factory :blood_group_description, class: "Renalware::BloodGroupDescription" do
    sequence(:code) { |n| "code_#{n}" }
    sequence(:name) { |n| "Name #{n}" }
    sequence(:position)
    enabled { true }
  end
end
