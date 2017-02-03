FactoryGirl.define do
  factory :role, class: "Renalware::Role" do
    name :super_admin
    hidden true

    trait :super_admin
    trait :admin do
      name :admin
      hidden false
    end
    trait :clinician do
      name :clinician
      hidden false
    end
    trait :read_only do
      name :read_only
      hidden false
    end
  end
end

def find_or_create_role(name = :super_admin)
  Renalware::Role.find_by(name: name) || create(:role, name)
end
