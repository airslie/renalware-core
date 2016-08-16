FactoryGirl.define do
  factory :edta_code, class: "Renalware::Deaths::EDTACode" do
    code "111"
    death_cause "Septicaemia"
  end
end
