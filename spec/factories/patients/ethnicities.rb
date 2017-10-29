FactoryBot.define do
  factory :ethnicity, class: "Renalware::Patients::Ethnicity" do
    name "White - British"
    rr18_code "A"

    trait :white_british do
    end
  end
end
