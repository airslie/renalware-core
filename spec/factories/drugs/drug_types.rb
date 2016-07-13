FactoryGirl.define do
  factory :drug_type, class: "Renalware::Drugs::Type" do
    code "immuno"
    name "Immunosuppressant"
  end
end
