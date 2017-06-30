FactoryGirl.define do
  factory :address, class: "Renalware::Address" do
    street_1 "123 Legoland"
    street_2 "Brewster Road"
    street_3 "Brownswater"
    town "Windsor"
    county "Berkshire"
    country "England"
    postcode "NW1 6BB"
  end
end
