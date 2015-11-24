FactoryGirl.define do
  sequence :gp_code do |n|
    "GP123#{n}"
  end

  factory :doctor, class: "Renalware::Doctor" do
    given_name 'Donald'
    family_name 'Good'
    email 'donald.good@nhs.net'
    code { generate(:gp_code) }
    address
    practitioner_type 'GP'
  end

end
