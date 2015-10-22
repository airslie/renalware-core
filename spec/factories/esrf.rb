FactoryGirl.define do
  factory :esrf, class: "Renalware::ESRF" do
    patient
    diagnosed_on Time.now
    prd_description
  end
end