FactoryGirl.define do
  sequence :practice_code do |n|
    "PR432#{n}"
  end
  factory :practice, class: "Renalware::Practice" do
    name 'Trumpton Medical Centre'
    email 'admin@trumptonmedicalcentre-nhs.net'
    address
    code { generate(:practice_code) }
  end
end
