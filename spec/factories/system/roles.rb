FactoryGirl.define do
  factory :role, class: "Renalware::Role" do
    name :super_admin
    hidden false

    trait :super_admin do
      name :super_admin
      hidden true
    end

    trait :admin do
      name :admin
    end

    trait :clinician do
      name :clinician
    end

    trait :read_only do
      name :read_only
    end
  end
end

def find_or_create_role(name = :clinician)
  Renalware::Role.find_by(name: name) || create(:role, name)
end
