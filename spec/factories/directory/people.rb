FactoryGirl.define do
  factory :directory_person, class: "Renalware::Directory::Person" do
    given_name   { Faker::Name.first_name }
    family_name  { Faker::Name.last_name }
    title        { Faker::Name.prefix }
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
