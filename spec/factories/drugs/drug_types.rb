FactoryGirl.define do
  factory :drug_type, class: "Renalware::Drugs::Type" do
    code "immuno"
    name "Immunosuppressant"

    trait :immunosuppressant do
      code "immunosuppressant"
      name "Immunosuppressant"
    end
  end
end
