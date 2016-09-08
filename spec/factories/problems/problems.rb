FactoryGirl.define do
  factory :problem, class: "Renalware::Problems::Problem" do
    description "further description of the patient problem"
    association :created_by,  factory: :user
    association :updated_by,  factory: :user
  end
end
