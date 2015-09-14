FactoryGirl.define do
  factory :drug_drug_type, class: "Renalware::DrugDrugType" do
    drug
    drug_type
  end

end
