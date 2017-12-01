FactoryBot.define do
  factory :role, class: "Renalware::Role" do
    initialize_with { Renalware::Role.find_or_create_by(name: name) }

    name :super_admin
    hidden false

    trait :super_admin do
      name :super_admin
      hidden true
    end

    trait :admin do
      name :admin
    end

    trait :read_write do
      name :read_write
    end

    trait :read_only do
      name :read_only
    end
  end
end
