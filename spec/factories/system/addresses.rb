FactoryBot.define do
  factory :address, class: "Renalware::Address" do
    street_1 "123 Legoland"
    street_2 "Brewster Road"
    street_3 "Brownswater"
    town "Windsor"
    county "Berkshire"
    country { Renalware::System::Country.find_by(alpha2: "GB") }
    postcode "NW1 6BB"
  end
end
