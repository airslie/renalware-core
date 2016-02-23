FactoryGirl.define do
  factory :hd_profile, class: "Renalware::HD::Profile" do
    patient
    association :hospital_unit, factory: :hospital_unit
    association :prescriber, factory: :user
    association :created_by,  factory: :user
    association :updated_by,  factory: :user

    document {
      {
        dialysis: {
          hd_type: :hd
        }
      }
    }
  end
end
