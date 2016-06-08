FactoryGirl.define do
  factory :renal_profile, class: "Renalware::Renal::Profile" do
    diagnosed_on Time.now
    prd_description
  end
end
