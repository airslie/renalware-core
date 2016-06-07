FactoryGirl.define do
  sequence :gp_code do |n|
    "GP123#{n}"
  end

  factory :doctor, class: "Renalware::Doctor" do
    given_name "Donald"
    family_name "Good"
    email "donald.good@nhs.net"
    telephone "0203593082"
    code { generate(:gp_code) }
    practitioner_type "GP"

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryGirl's simple assoc method does not work
    #
    before(:create) do |doctor|
      doctor.build_address(attributes_for(:address))
    end
  end
end
