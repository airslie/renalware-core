FactoryBot.define do
  sequence :gp_code do |n|
    "GP123#{n}"
  end

  factory :primary_care_physician, class: "Renalware::Patients::PrimaryCarePhysician" do
    given_name "Donald"
    family_name "Good"
    email "donald.good@nhs.net"
    telephone "0203593082"
    code { generate(:gp_code) }
    practitioner_type "GP"

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryBot's simple assoc method does not work
    #
    before(:create) do |primary_care_physician|
      primary_care_physician.build_address(attributes_for(:address))
    end
  end
end
