FactoryBot.define do
  factory :address, class: "Renalware::Address" do
    street_1 "123 Legoland"
    street_2 "Brewster Road"
    street_3 "Brownswater"
    town "Windsor"
    county "Berkshire"
    country { Renalware::System::Country.find_by(alpha2: "GB") }
    postcode "NW1 6BB"
    telephone "118118"
    email "email@example.com"

    trait :in_uk do
      association(:country, factory: :united_kingdom)
    end
  end
end
