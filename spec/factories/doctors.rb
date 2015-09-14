FactoryGirl.define do
  sequence :gp_code do |n|
    "GP123#{n}"
  end

  factory :doctor, class: "Renalware::Doctor" do
    first_name 'Donald'
    last_name 'Good'
    email 'donald.good@nhs.net'
    code { generate(:gp_code) }
    address
    practitioner_type 'GP'
  end

end
